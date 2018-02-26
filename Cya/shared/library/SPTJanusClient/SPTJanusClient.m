//
//  SPTJanusClient.m
//  Synaparty
//
//  Created by Mykola Burynok on 16-03-29.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "SPTJanusClient.h"

#import <AVFoundation/AVFoundation.h>

#import <libjingle_peerconnection/RTCPeerConnection.h>
#import <libjingle_peerconnection/RTCMediaConstraints.h>
#import <libjingle_peerconnection/RTCPair.h>
#import <libjingle_peerconnection/RTCPeerConnectionDelegate.h>
#import <libjingle_peerconnection/RTCPeerConnectionFactory.h>
#import <libjingle_peerconnection/RTCMediaStream.h>
#import <libjingle_peerconnection/RTCSessionDescriptionDelegate.h>
#import <libjingle_peerconnection/RTCVideoCapturer.h>
#import <libjingle_peerconnection/RTCVideoTrack.h>

#import "SPTSignalingMessage.h"
#import "SPTMessageResponse.h"
#import "SPTUtilities.h"

//can be in other classes
#import <libjingle_peerconnection/RTCICEServer.h>

#import "RTCSessionDescription+JSON.h"
#import "RTCICEServer+JSON.h"

//#import "SPTDataProvider.h"

//#import "Request.h"

// TODO(tkchin): move these to a configuration object.
static NSString *kSPTJanusHostUrl =
@"https://%@";
static NSString *kSPTJanusSessionHostUrl =
@"https://%@%@";
static NSString *kSPTJanusPluginHostUrl =
@"https://%@%@/%@";

static NSString *kSPTRoomServerMessageFormat =
@"%@/message/%@/%@";
static NSString *kSPTRoomServerByeFormat =
@"%@/leave/%@/%@";

static NSString *kSPTDefaultSTUNServerUrl =
@"stun:stun.l.google.com:19302";

// TODO(tkchin): figure out a better username for CEOD statistics.
static NSString *kSPTTurnRequestUrl =
@"https://computeengineondemand.appspot.com"
@"/turn?username=iapprtc&key=4080218913";

static NSString *kSPTJanusClientErrorDomain = @"ARDAppClient";
//static NSInteger kSPTJanusClientErrorUnknown = -1;
//static NSInteger kSPTJanusClientErrorRoomFull = -2;
static NSInteger kSPTJanusClientErrorCreateSDP = -3;
static NSInteger kSPTJanusClientErrorSetSDP = -4;
static NSInteger kSPTJanusClientErrorNetwork = -5;
//static NSInteger kSPTJanusClientErrorInvalidClient = -6;
//static NSInteger kSPTJanusClientErrorInvalidRoom = -7;


@interface SPTJanusClient ()  <NSURLSessionDelegate, RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate> {
    
    SPTSessionDescriptionMessage *_sdpMessage;
}

@property (nonatomic, strong) RTCPeerConnection * peerConnection;
@property (nonatomic, strong) RTCPeerConnectionFactory *factory;


@property (nonatomic, readonly) BOOL isRegisteredWithRoomServer;

@property (nonatomic, strong) NSString *host;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *janusSessionId;
@property (nonatomic, strong) NSString *janusPluginId;
@property (nonatomic, strong) NSString *janusPluginRoomId;
@property (nonatomic, strong) NSString *pin;

@property (nonatomic, strong) NSString *clientId;

@property (nonatomic, strong) NSMutableArray *candidatesArray;
@property (nonatomic, strong) NSString *jsepString;
//@property (nonatomic, strong) NSString *roomIdString;
@property (nonatomic, strong) NSString *firstPublisherIdString;

@property(nonatomic, strong) NSMutableArray *iceServers;

@property(nonatomic, assign) BOOL isSpeakerEnabled;
@property(nonatomic, strong) RTCAudioTrack *defaultAudioTrack;
@property(nonatomic, strong) RTCVideoTrack *defaultVideoTrack;

@end

@implementation SPTJanusClient

@synthesize isInitiator = _isInitiator;

@synthesize janusSessionId = _janusSessionId;
//@synthesize pluginId = _pluginId;
//@synthesize roomId = _roomId;
@synthesize iceServers = _iceServers;

#pragma mark - Life Cicle Methods

- (instancetype)initWithDelegate:(id<SPTJanusClientDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _factory = [[RTCPeerConnectionFactory alloc] init];
//        _messageQueue = [NSMutableArray array];
        _iceServers = [NSMutableArray arrayWithObject:[self defaultSTUNServer]];

//        _serverHostUrl = kSPTJanusHostUrl;
//        _isSpeakerEnabled = YES;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(orientationChanged:)
//                                                     name:@"UIDeviceOrientationDidChangeNotification"
//                                                   object:nil];
        _candidatesArray = [NSMutableArray array];
        _isInitiator = NO;
    }
    return self;
}

#pragma mark - Janus Methods

- (void)createJanusSessionWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusHostUrl, self.host];
    NSString * params = @"{\"janus\":\"create\", \"transaction\":\"create_transaction\"}";
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)destroyJanusSessionWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusSessionHostUrl, self.host, self.janusSessionId];
    NSString * params = @"{\"janus\":\"destroy\", \"transaction\":\"destroy_transaction\"}";
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)attachJanusPluginVideoroomWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusSessionHostUrl, self.host, self.janusSessionId];
    NSString * params = @"{\"janus\":\"attach\", \"plugin\":\"janus.plugin.videoroom\", \"transaction\":\"attach_videoroom\"}";
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)detachJanusPluginVideoroomWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = @"{\"janus\":\"detach\", \"transaction\":\"detach_videoroom\"}";
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)roomListJanusPluginVideoroomWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = @"{\"janus\":\"message\", \"transaction\":\"message_list_videoroom\", \"body\":{\"request\":\"list\"}}";
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)roomParticipantsListJanusPluginVideoroomWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_list_participants_videoroom\", \"body\":{\"request\":\"listparticipants\", \"room\":%@}}", self.janusPluginRoomId];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)roomCreateJanusPluginVideoroomWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = @"{\"janus\":\"message\", \"transaction\":\"message_create_videoroom\", \"body\":{\"request\":\"create\"}}";
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)roomDestroyJanusPluginVideoroomWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = [NSString stringWithFormat: @"{\"janus\":\"message\", \"transaction\":\"message_destroy_videoroom\", \"body\":{\"request\":\"destroy\", \"room\":%@}}", self.janusPluginRoomId];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)roomJoinRequestWithFeedId:(NSString *)feed completionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    
    NSString *params = @"";
    
    NSString * userid = @"343971"; //[[SPTDataProvider sharedInstance] getUserId];
    
    if (_isInitiator) {
        // for publishers
        
        // TODO: change STAGEAPI_SESSION_ID to a dynamic one
        params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_join_videoroom\", \"body\":{\"request\":\"join\", \"room\":%@, \"pin\":\"%@\", \"display\":\"%s:%@\", \"id\":%@, \"ptype\":\"publisher\"}}", self.janusPluginRoomId, self.pin, "931bc20500b44535b1fe7477cf048bd1", userid, userid];
        
        // params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_join_videoroom\", \"body\":{\"request\":\"join\", \"room\":%@, \"pin\":\"%@\", \"display\":\"%s:%@\", \"id\":%@, \"ptype\":\"publisher\"}}", self.janusPluginRoomId, self.pin, STAGEAPI_SESSION_ID, userid, userid];
    } else {
        // for listeners
        params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_join_videoroom\", \"body\":{\"request\":\"join\", \"room\":%@, \"pin\":\"%@\", \"ptype\":\"listener\", \"feed\":%@}}", self.janusPluginRoomId, self.pin, feed];
    }
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (_isInitiator) {
            
            for (SPTICECandidateMessage *message in self.candidatesArray) {
                [self trickleCandidate:message];
            }
            
            [self completeTrickleCandidate];
        }
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)roomLeaveRequestWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_leave_videoroom\", \"body\":{\"request\":\"leave\", \"room\":%@}}", self.janusPluginRoomId];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)initJanusPeerConnectionWithJsep:(NSString *)jsep completionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    
    NSString *params = @"";
    
    if (_isInitiator) {
        // for publishers
        params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_offer_videoroom\", \"body\":{\"audio\":true, \"video\":true, \"request\":\"configure\"}, \"jsep\":%@}", jsep];
    } else {
        // for listeners
        params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_listen_videoroom\", \"body\":{\"audio\":true, \"video\":true}}"];
    }
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"123%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)trickleCandidate:(SPTICECandidateMessage *)message {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = [NSString stringWithFormat:@"{\"janus\":\"trickle\", \"transaction\":\"trickle_candidate_videoroom\", \"candidate\":{\"sdpMid\":\"%@\", \"sdpMLineIndex\":%li, \"candidate\":\"%@\"}}", message.candidate.sdpMid, (long)message.candidate.sdpMLineIndex, message.candidate];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
//        NSError * localError = nil;
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"trickle candidate response: %@: %@", dic[@"transaction"], dic);
        
//        if (completionBlock) {
//            completionBlock(dic, error);
//        }
    }];
}

- (void)completeTrickleCandidate {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    NSString * params = [NSString stringWithFormat:@"{\"janus\":\"trickle\", \"transaction\":\"completed_trickle_candidate_videoroom\", \"candidate\":{\"completed\":true}}"];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
//        NSError * localError = nil;
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
//        
//        NSLOG(@"trickle candidate response: %@: %@", dic[@"transaction"], dic);
//        
//        if (completionBlock) {
//            completionBlock(dic, error);
//        }
    }];
}

- (void)listenJanusPeerConnectionWithJsep:(NSString *)jsep completionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusPluginHostUrl, self.host, self.janusSessionId, self.janusPluginId];
    
    // for listeners
    NSString * params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_answer_videoroom\", \"body\":{\"request\":\"start\", \"room\":%@}, \"jsep\":%@}", self.janusPluginRoomId, jsep];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"listen result: %@: %@ \njspe: %@", dic[@"transaction"], dic, self.jsepString);
        
        for (SPTICECandidateMessage *message in self.candidatesArray) {
            [self trickleCandidate:message];
        }
        
        [self completeTrickleCandidate];
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)longpollEventRequestWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusSessionHostUrl, self.host, self.janusSessionId];
    NSString * params = @"...Long Poll GET Request...";
    
    __weak SPTJanusClient * weakSelf = self;
    
    __block void (^weak_apply)(NSInteger);
    void(^apply)(NSInteger);
    weak_apply = apply = ^(NSInteger someInteger){
    
        [self makeGetRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
            
            NSError * localError = nil;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
            
//            NSLOG(@"longpool_videoroom_transaction: %@", dic);
            
            BOOL keepAlive = NO;
            keepAlive = [dic[@"janus"] isEqualToString:@"keepalive"] ? YES : NO;
            
            NSDictionary *jsep = dic[@"jsep"];
            
            if (keepAlive) {
                weak_apply(1);
            } else {
                
                if (jsep) {
                    
//                    NSDictionary *plugindataDic = dic[@"plugindata"];
//                    NSDictionary *attachedDataDic = plugindataDic[@"data"];
                    
//                    self.roomIdString = attachedDataDic[@"room"];
                    
//                    NSArray *publishersArray = attachedDataDic[@"publishers"];
//                    NSDictionary *firstPublisherDic = [publishersArray objectAtIndex:0];
//                    self.firstPublisherIdString = firstPublisherDic[@"id"];
                    
                    [weakSelf proceedRemoteJSEP:jsep];
                }
                
                [weakSelf handleLongPollResponseDictionary:dic];
                weak_apply(1);
            }
        }];
    };
    
    apply(1);
}

- (void)makeGetRequestToURL:(NSString *)urlString withParams:(NSString*)params completionBlock:(void(^)(id JSON, NSError *error))completionBlock {
    
//    NSLOG(@"Loading data from Janus: %@%@", urlString, params);
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   
                   if (!error) {
                       NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
//                       NSLOG(@"response header: %@", httpResp);
//                       NSLOG(@"response body: %@", [NSString stringWithUTF8String:[data bytes]]);
                       
                       if (httpResp.statusCode == 200) {
                           
                           completionBlock(data, error);
                       }
                       else{
//                           NSLOG(@"Error loading data:%@\n ", error);
                       }
                   } else {
//                       NSLOG(@"Error loading data:%@\n ", error);
                   }
               }];
    
    [dataTask resume];
}

- (void)makePostRequestToURL:(NSString *)urlString withParams:(NSString*)params completionBlock:(void(^)(id JSON, NSError *error))completionBlock {
    
//    NSLOG(@"Loading data from Janus: %@%@", urlString, params);
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSData *paramsData = [params dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:paramsData];
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   
                   if (!error) {
                       NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
//                       NSLOG(@"response header: %@", httpResp);
//                       NSLOG(@"response body: %@", [NSString stringWithUTF8String:[data bytes]]);
                       
                       if (httpResp.statusCode == 200) {
                           
                           completionBlock(data, error);
                       }
                       else{
//                           NSLOG(@"Error loading data:%@\n status code: %ld", error, (long)httpResp.statusCode);
                       }
                   } else {
//                       NSLOG(@"Error loading data:%@\n ", error);
                   }
               }];
    
    [dataTask resume];
}

- (void)handleLongPollResponseDictionary:(NSDictionary *)responseDictionary {
    
    NSString * transactionString = responseDictionary[@"transaction"];
    
    if ([transactionString isEqualToString:@"message_join_videoroom"] && ![responseDictionary[@"janus"] isEqualToString:@"ack"]) {
        if (_isInitiator) {
            [self initJanusPeerConnectionWithJsep:self.jsepString completionBlock:^(NSDictionary *JSONDic, NSError *error) {
                
            }];
            
//            [self roomLeaveRequestWithSessionId:_sessionId pluginId:_pluginId roomId:_roomId completionBlock:^(NSDictionary *JSONDic, NSError *error) {
//                NSLOG(@"ROOM LEFT");
//            }];
            
//            [self roomDestroyJanusPluginVideoroomWithSessionId:_sessionId pluginId:_pluginId roomId:_roomId completionBlock:^(NSDictionary *JSONDic, NSError *error) {
//                [self roomListJanusPluginVideoroomWithSessionId:_sessionId pluginId:_pluginId completionBlock:^(NSDictionary *JSONDic, NSError *error) {
//                    
//                }];
//            }];
        } else {
            
            
        }
    }
}

- (void)sendAnswerSDP {
    
    [self listenJanusPeerConnectionWithJsep:self.jsepString completionBlock:^(NSDictionary *JSONDic, NSError *error) {
        
    }];
}

#pragma mark - Defaults

- (RTCMediaConstraints *)defaultMediaStreamConstraints {
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:nil
     optionalConstraints:nil];
    return constraints;
}

- (RTCMediaConstraints *)defaultAnswerConstraints {
    return [self defaultOfferConstraints];
}

- (RTCMediaConstraints *)defaultOfferConstraints {
    
    NSArray *mandatoryConstraints = @[
                                      [[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"],
                                      [[RTCPair alloc] initWithKey:@"OfferToReceiveVideo" value:@"true"]
                                      ];
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:mandatoryConstraints
     optionalConstraints:nil];
    return constraints;
}

- (RTCMediaConstraints *)defaultPeerConnectionConstraints {
    
    RTCPair *localVideoMaxWidth = [[RTCPair alloc] initWithKey:@"maxWidth" value:@"240"];
    RTCPair *localVideoMinWidth = [[RTCPair alloc] initWithKey:@"minWidth" value:@"240"];
    RTCPair *localVideoMaxHeight = [[RTCPair alloc] initWithKey:@"maxHeight" value:@"320"];
    RTCPair *localVideoMinHeight = [[RTCPair alloc] initWithKey:@"minHeight" value:@"320"];
    //    RTCPair *localVideoMaxFrameRate = [[RTCPair alloc] initWithKey:@"maxFrameRate" value:@"30"];
    //    RTCPair *localVideoMinFrameRate = [[RTCPair alloc] initWithKey:@"minFrameRate" value:@"5"];
    //    RTCPair *localVideoGoogLeakyBucket = [[RTCPair alloc] initWithKey:@"googLeakyBucket" value:@"true"];
    
    NSArray *optionalConstraints = @[
                                     [[RTCPair alloc] initWithKey:@"DtlsSrtpKeyAgreement" value:@"true"],
                                     localVideoMaxWidth,
                                     localVideoMinWidth,
                                     localVideoMaxHeight,
                                     localVideoMinHeight
                                     ];
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:nil
     optionalConstraints:optionalConstraints];
    return constraints;
}

- (RTCICEServer *)defaultSTUNServer {
    NSURL *defaultSTUNServerURL = [NSURL URLWithString:kSPTDefaultSTUNServerUrl];
    return [[RTCICEServer alloc] initWithURI:defaultSTUNServerURL
                                    username:@""
                                    password:@""];
}

#pragma mark - RTCPeerConnectionDelegate Methods

// Triggered when the SignalingState changed.
- (void)peerConnection:(RTCPeerConnection *)peerConnection signalingStateChanged:(RTCSignalingState)stateChanged {
//    NSLOG(@"Signaling state changed: %d", stateChanged);
}

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection addedStream:(RTCMediaStream *)stream {
//    NSLOG(@"Received %lu video tracks and %lu audio tracks", (unsigned long)stream.videoTracks.count, (unsigned long)stream.audioTracks.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"Received %lu video tracks and %lu audio tracks",
//              (unsigned long)stream.videoTracks.count,
//              (unsigned long)stream.audioTracks.count);
        if (stream.videoTracks.count) {
            RTCVideoTrack *videoTrack = stream.videoTracks[0];
            [_delegate appClient:self didReceiveRemoteVideoTrack:videoTrack];
            if (_isSpeakerEnabled) [self enableSpeaker]; //Use the "handsfree" speaker instead of the ear speaker.
            
        }
    });
}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection removedStream:(RTCMediaStream *)stream {
//    NSLOG(@"Stream was removed.");
}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection {
//    NSLOG(@"WARNING: Renegotiation needed but unimplemented.");
}

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection iceConnectionChanged:(RTCICEConnectionState)newState {
//    NSLOG(@"ICE state changed: %d", newState);
}

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection iceGatheringChanged:(RTCICEGatheringState)newState {
//    NSLOG(@"ICE gathering state changed: %d", newState);
}

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection gotICECandidate:(RTCICECandidate *)candidate {
//    NSLOG(@"got ICE Candidate: %@", candidate);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SPTICECandidateMessage *message =
        [[SPTICECandidateMessage alloc] initWithCandidate:candidate];
//        [self sendSignalingMessage:message];
        
        [self.candidatesArray addObject:message];
    });
}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection didOpenDataChannel:(RTCDataChannel*)dataChannel {
//    NSLOG(@"did Open Data Channel");
}

#pragma mark - RTCSessionDescriptionDelegate Methods

// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection didCreateSessionDescription:(RTCSessionDescription *)sdp error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
//            NSLOG(@"Failed to create session description. Error: %@", error);
            [self disconnect];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Failed to create session description."};
            NSError *sdpError = [[NSError alloc] initWithDomain:kSPTJanusClientErrorDomain code:kSPTJanusClientErrorCreateSDP userInfo:userInfo];
            [_delegate appClient:self didError:sdpError];
            return;
        }
        [_peerConnection setLocalDescriptionWithDelegate:self sessionDescription:sdp];
        
        SPTSessionDescriptionMessage *message = [[SPTSessionDescriptionMessage alloc] initWithDescription:sdp];
        self.jsepString = (NSString *)message;
        [self sendSignalingMessage:message];
        
        if (!_isInitiator) {
            [self sendAnswerSDP];
        } else {
            [self initJanusConnection];
        }
    });
}

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection didSetSessionDescriptionWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
//            NSLOG(@"Failed to set session description. Error: %@", error);
            [self disconnect];
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: @"Failed to set session description.",
                                       };
            NSError *sdpError =
            [[NSError alloc] initWithDomain:kSPTJanusClientErrorDomain
                                       code:kSPTJanusClientErrorSetSDP
                                   userInfo:userInfo];
            [_delegate appClient:self didError:sdpError];
            return;
        }
        
//        NSLOG(@"start peer connection...%u ", _peerConnection.signalingState);
        
        // If we're answering and we've just set the remote offer we need to create
        // an answer and set the local description.
        if (!_isInitiator && !_peerConnection.localDescription) {
            
            RTCMediaConstraints *constraints = [self defaultAnswerConstraints];
            [_peerConnection createAnswerWithDelegate:self
                                          constraints:constraints];
        }
    });
}

#pragma mark - Miscellaneous Methods

- (void)proceedRemoteJSEP:(NSDictionary *)jsep {
    
    // for listeners
    if ([jsep[@"type"] isEqualToString:@"answer"] || [jsep[@"type"] isEqualToString:@"offer"]) {
        
        RTCSessionDescription *description =
        [RTCSessionDescription descriptionFromJSONDictionary:jsep];
        
        [_peerConnection setRemoteDescriptionWithDelegate:self
                                       sessionDescription:description];
    }
}

- (void)connectWithUserInfo:(NSDictionary *)userInfo {
    
    
}

- (void)createWebRTCPeerConnectionAsInitiator:(BOOL)initiator
                                     userInfo:(NSDictionary *)userInfo {
    // TODO
    
    // synapcast gen 2
//    self.host = userInfo[@"host"];
//    self.janusPluginRoomId = userInfo[@"room"];
//    self.pin = userInfo[@"pin"];
    
    // synapcast gen 3
    self.host = userInfo[@"room"][@"host"];
    self.janusPluginRoomId = userInfo[@"room"][@"id"];
    self.pin = userInfo[@"room"][@"pin"];
    
    self.isInitiator = initiator;
    
    // Request TURN.
//    NSLOG(@"request turn servers");
    __weak SPTJanusClient *weakSelf = self;
    NSURL *turnRequestURL = [NSURL URLWithString:kSPTTurnRequestUrl];
    [self requestTURNServersWithURL:turnRequestURL
                  completionHandler:^(NSArray *turnServers) {
                      
                      SPTJanusClient *strongSelf = weakSelf;
                      [strongSelf.iceServers addObjectsFromArray:turnServers];
//                      strongSelf.isTurnComplete = YES;
//                      [strongSelf startSignalingIfReady];
                      
//                      NSLog(@"iceServers: %@", strongSelf.iceServers);
                      
                      [strongSelf createPeerConection];
                  }];
}

- (void)createPeerConection {
    
//    NSLOG(@"create peer connection");
    
    // create peer connection
    RTCMediaConstraints * constraints = [self defaultPeerConnectionConstraints];
    _peerConnection = [_factory peerConnectionWithICEServers:_iceServers constraints:constraints delegate:self];
    
    if (_isInitiator) {
        RTCMediaStream *localStream = [self createLocalMediaStream];
        [_peerConnection addStream:localStream];
        // send offer
        [_peerConnection createOfferWithDelegate:self constraints:[self defaultOfferConstraints]];
    } else {
//        [self waitForAnswer];
        
        [self initJanusConnection];
    }
}

- (void)waitForAnswer {
    [self drainMessageQueueIfReady];
}

- (void)drainMessageQueueIfReady {
//    if (!_peerConnection || !_hasReceivedSdp) {
//        return;
//    }
//    for (SPTSignalingMessage *message in _messageQueue) {
//        [self processSignalingMessage:message];
//    }
//    [_messageQueue removeAllObjects];
}

- (void)sendSignalingMessage:(SPTSignalingMessage *)message {
    if (_isInitiator) {
//        [self sendSignalingMessageToRoomServer:message completionHandler:nil];
    } else {
        
    }
}

- (void)sendSignalingMessageToRoomServer:(SPTSignalingMessage *)message
                       completionHandler:(void (^)(SPTMessageResponse *))completionHandler {
//    NSData *data = [message JSONData];
    NSString *urlString =
    [NSString stringWithFormat:
     kSPTRoomServerMessageFormat, self.serverHostUrl, self.janusPluginRoomId, _clientId];
//    NSLog(@"urlStringurlStringurlString: %@", urlString);
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSLog(@"C->RS POST: %@", message);
//    __weak SPTJanusClient *weakSelf = self;
//    [NSURLConnection sendAsyncPostToURL:url
//                               withData:data
//                      completionHandler:^(BOOL succeeded, NSData *data) {
//                          SPTJanusClient *strongSelf = weakSelf;
//                          if (!succeeded) {
//                              NSError *error = [self roomServerNetworkError];
//                              [strongSelf.delegate appClient:strongSelf didError:error];
//                              return;
//                          }
//                          SPTMessageResponse *response =
//                          [SPTMessageResponse responseFromJSONData:data];
//                          NSError *error = nil;
//                          switch (response.result) {
//                              case kSPTMessageResponseTypeSuccess:
//                                  break;
//                              case kSPTMessageResponseTypeUnknown:
//                                  error =
//                                  [[NSError alloc] initWithDomain:kSPTJanusClientErrorDomain
//                                                             code:kSPTJanusClientErrorUnknown
//                                                         userInfo:@{
//                                                                    NSLocalizedDescriptionKey: @"Unknown error.",
//                                                                    }];
//                              case kSPTMessageResponseTypeInvalidClient:
//                                  error =
//                                  [[NSError alloc] initWithDomain:kSPTJanusClientErrorDomain
//                                                             code:kSPTJanusClientErrorInvalidClient
//                                                         userInfo:@{
//                                                                    NSLocalizedDescriptionKey: @"Invalid client.",
//                                                                    }];
//                                  break;
//                              case kSPTMessageResponseTypeInvalidRoom:
//                                  error =
//                                  [[NSError alloc] initWithDomain:kSPTJanusClientErrorDomain
//                                                             code:kSPTJanusClientErrorInvalidRoom
//                                                         userInfo:@{
//                                                                    NSLocalizedDescriptionKey: @"Invalid room.",
//                                                                    }];
//                                  break;
//                          };
//                          if (error) {
//                              [strongSelf.delegate appClient:strongSelf didError:error];
//                          }
//                          if (completionHandler) {
//                              completionHandler(response);
//                          }
//                      }];
}

- (NSError *)roomServerNetworkError {
    NSError *error =
    [[NSError alloc] initWithDomain:kSPTJanusClientErrorDomain
                               code:kSPTJanusClientErrorNetwork
                           userInfo:@{
                                      NSLocalizedDescriptionKey: @"Room server network error",
                                      }];
    return error;
}

- (void)disconnect {
    
    
//    if (_state == kSPTJanusClientStateDisconnected) {
//        return;
//    }
    
    if (self.isRegisteredWithRoomServer) {
        [self unregisterWithRoomServer];
    }
    
    [self roomLeaveRequestWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
        [self detachJanusPluginVideoroomWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
            [self destroyJanusSessionWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
                
            }];
        }];
    }];
    
//    if (_channel) {
//        if (_channel.state == kARDWebSocketChannelStateRegistered) {
//            // Tell the other client we're hanging up.
//            SPTByeMessage *byeMessage = [[SPTByeMessage alloc] init];
//            NSData *byeData = [byeMessage JSONData];
//            [_channel sendData:byeData];
//        }
//        // Disconnect from collider.
//        _channel = nil;
//    }
    
    _clientId = nil;
    self.janusPluginRoomId = nil;
    _isInitiator = NO;
    //    _hasReceivedSdp = NO;
    //    _messageQueue = [NSMutableArray array];
    _peerConnection = nil;
    //    self.state = kSPTJanusClientStateDisconnected;
}

- (void)unregisterWithRoomServer {
    NSString *urlString =
    [NSString stringWithFormat:kSPTRoomServerByeFormat, self.serverHostUrl, self.janusPluginRoomId, _clientId];
    NSURL *url = [NSURL URLWithString:urlString];
//    NSLog(@"C->RS: BYE");
    //Make sure to do a POST
    
    [NSURLConnection sendAsyncPostToURL:url withData:nil completionHandler:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
//            NSLog(@"Unregistered from room server.");
        } else {
//            NSLog(@"Failed to unregister from room server.");
        }
    }];
}

- (void)initJanusConnection {
    
//    NSLOG(@"<--------- Start JanusClient Connection --------->");
    
    [self createJanusSessionWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
        NSDictionary * dataDic = JSONDic[@"data"];
        self.janusSessionId = dataDic[@"id"];
        
        [self attachJanusPluginVideoroomWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
            NSDictionary *pluginDic = JSONDic[@"data"];
            self.janusPluginId = pluginDic[@"id"];
            
            // long poll request handler
            [self longpollEventRequestWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
            }];
            
            // join video room
            if (_isInitiator) {
                
                // TODO: remove hardcoded data
                [self roomJoinRequestWithFeedId:@"1235" completionBlock:^(NSDictionary *JSONDic, NSError *error) {
                    
                }];
            } else {
                [self roomParticipantsListJanusPluginVideoroomWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
                    
                    // get first publisher id if exists to use it as feed attibute to listen
                    NSDictionary * pluginDataDictionary = JSONDic[@"plugindata"];
                    NSDictionary * dataDictionary = pluginDataDictionary[@"data"];
                    NSArray * publishersArray = dataDictionary[@"participants"];
                    if ([publishersArray count] > 0) {
                        NSDictionary * firstPublisherDictionary = [publishersArray objectAtIndex:0];
                        
//                        [[SPTDataProvider sharedInstance]getUserId];
                        
                        [self roomJoinRequestWithFeedId:firstPublisherDictionary[@"id"] completionBlock:^(NSDictionary *JSONDic, NSError *error) {

                        }];
                    }
                }];
            }
        }];
    }];
}

#pragma mark - Private Methods

- (RTCVideoTrack *)createLocalVideoTrack {
    // The iOS simulator doesn't provide any sort of camera capture
    // support or emulation (http://goo.gl/rHAnC1) so don't bother
    // trying to open a local stream.
    // TODO(tkchin): local video capture for OSX. See
    // https://code.google.com/p/webrtc/issues/detail?id=3417.
    
    RTCVideoTrack *localVideoTrack = nil;
#if !TARGET_IPHONE_SIMULATOR && TARGET_OS_IPHONE
    
    NSString *cameraID = nil;
    for (AVCaptureDevice *captureDevice in
         [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (captureDevice.position == AVCaptureDevicePositionFront) {
            cameraID = [captureDevice localizedName];
            //            NSLog(@"cameraID: %@", cameraID);
            break;
        }
    }
    NSAssert(cameraID, @"Unable to get the front camera id");
    
    RTCVideoCapturer *capturer = [RTCVideoCapturer capturerWithDeviceName:cameraID];
    RTCMediaConstraints *mediaConstraints = [self defaultMediaStreamConstraints];
    RTCVideoSource *videoSource = [_factory videoSourceWithCapturer:capturer constraints:mediaConstraints];
    localVideoTrack = [_factory videoTrackWithID:@"ARDAMSv0" source:videoSource];
#endif
    return localVideoTrack;
}

- (RTCMediaStream *)createLocalMediaStream {
    
    NSString * nameLocalStream = [NSString stringWithFormat:@"ARDAMS%@", @"343971"];
    // NSString * nameLocalStream = [NSString stringWithFormat:@"ARDAMS%@", [[SPTDataProvider sharedInstance]getUserId]];
    
    RTCMediaStream* localStream = [_factory mediaStreamWithLabel:nameLocalStream];
//    RTCMediaStream* localStream = [_factory mediaStreamWithLabel:@"ARDAMS"];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
    }
    
    NSString * nameaddAudioTrack = [NSString stringWithFormat:@"ARDAMSa0"];
    RTCAudioTrack * audioTrack = [_factory audioTrackWithID:nameaddAudioTrack];
    [localStream addAudioTrack:audioTrack];
    
//    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    if (_isSpeakerEnabled) [self enableSpeaker];
    return localStream;
}

- (void)requestTURNServersWithURL:(NSURL *)requestURL
                completionHandler:(void (^)(NSArray *turnServers))completionHandler {
    NSParameterAssert([requestURL absoluteString].length);
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:requestURL];
    // We need to set origin because TURN provider whitelists requests based on
    // origin.
    [request addValue:@"Mozilla/5.0" forHTTPHeaderField:@"user-agent"];
    [request addValue:self.serverHostUrl forHTTPHeaderField:@"origin"];
    [NSURLConnection sendAsyncRequest:request
                    completionHandler:^(NSURLResponse *response,
                                        NSData *data,
                                        NSError *error) {
                        NSArray *turnServers = [NSArray array];
                        if (error) {
//                            NSLog(@"Unable to get TURN server.");
                            completionHandler(turnServers);
                            return;
                        }
                        NSDictionary *dict = [NSDictionary dictionaryWithJSONData:data];
                        turnServers = [RTCICEServer serversFromCEODJSONDictionary:dict];
                        completionHandler(turnServers);
                    }];
}

#pragma mark - Audio mute/unmute
- (void)muteAudioIn {
//    NSLog(@"audio muted");
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    self.defaultAudioTrack = localStream.audioTracks[0];
    [localStream removeAudioTrack:localStream.audioTracks[0]];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}

- (void)unmuteAudioIn {
//    NSLog(@"audio unmuted");
    RTCMediaStream* localStream = _peerConnection.localStreams[0];
    [localStream addAudioTrack:self.defaultAudioTrack];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
    if (_isSpeakerEnabled) [self enableSpeaker];
}

#pragma mark - Video mute/unmute
- (void)muteVideoIn {
//    NSLog(@"video muted");
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    self.defaultVideoTrack = localStream.videoTracks[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}
- (void)unmuteVideoIn {
//    NSLog(@"video unmuted");
    RTCMediaStream* localStream = _peerConnection.localStreams[0];
    [localStream addVideoTrack:self.defaultVideoTrack];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}

#pragma mark - swap camera
- (RTCVideoTrack *)createLocalVideoTrackBackCamera {
    RTCVideoTrack *localVideoTrack = nil;
#if !TARGET_IPHONE_SIMULATOR && TARGET_OS_IPHONE
    //AVCaptureDevicePositionFront
    NSString *cameraID = nil;
    for (AVCaptureDevice *captureDevice in
         [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (captureDevice.position == AVCaptureDevicePositionBack) {
            cameraID = [captureDevice localizedName];
            break;
        }
    }
    NSAssert(cameraID, @"Unable to get the back camera id");
    
    RTCVideoCapturer *capturer = [RTCVideoCapturer capturerWithDeviceName:cameraID];
    RTCMediaConstraints *mediaConstraints = [self defaultMediaStreamConstraints];
    RTCVideoSource *videoSource = [_factory videoSourceWithCapturer:capturer constraints:mediaConstraints];
    localVideoTrack = [_factory videoTrackWithID:@"ARDAMSv0" source:videoSource];
#endif
    return localVideoTrack;
}
- (void)swapCameraToFront{
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
    
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
    }
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}
- (void)swapCameraToBack{
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrackBackCamera];
    
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
    }
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}

#pragma mark - enable/disable speaker

- (void)enableSpeaker {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    _isSpeakerEnabled = YES;
}

- (void)disableSpeaker {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    _isSpeakerEnabled = NO;
}

@end

//
//  SPTJanusStream.m
//  Synaparty
//
//  Created by Mykola Burynok on 16-05-05.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "SPTJanusStream.h"
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

// TODO(tkchin): move these to a configuration object.
//static NSString *kSPTJanusHostUrl =
//@"https://stg-sub-54-174-156-33.synaptop.com";
//static NSString *kSPTJanusSessionHostUrl =
//@"https://stg-sub-54-174-156-33.synaptop.com/%@";
//static NSString *kSPTJanusPluginHostUrl =
//@"https://stg-sub-54-174-156-33.synaptop.com/%@/%@";
//static NSString *kSPTRoomServerRegisterFormat =
//@"%@/join/%@";

static NSString *kSPTRoomServerMessageFormat =
@"%@/message/%@/%@";
static NSString *kSPTRoomServerByeFormat =
@"%@/leave/%@/%@";

static NSString *kSPTDefaultSTUNServerUrl =
@"stun:turn.synaptop.com:443";
//@"stun:stun.l.google.com:19302";

// TODO(tkchin): figure out a better username for CEOD statistics.
static NSString *kSPTTurnRequestUrl =
@"https://computeengineondemand.appspot.com"
@"/turn?username=iapprtc&key=4080218913";

static NSString *kSPTPluginNameStreaming =
@"janus.plugin.streaming";

static NSString *kSPTJanusClientErrorDomain = @"SPTClient";
//static NSInteger kSPTJanusClientErrorUnknown = -1;
//static NSInteger kSPTJanusClientErrorRoomFull = -2;
static NSInteger kSPTJanusClientErrorCreateSDP = -3;
static NSInteger kSPTJanusClientErrorSetSDP = -4;
static NSInteger kSPTJanusClientErrorNetwork = -5;
//static NSInteger kSPTJanusClientErrorInvalidClient = -6;
//static NSInteger kSPTJanusClientErrorInvalidRoom = -7;

@interface SPTJanusStream () <NSURLSessionDelegate, RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate> {
    
    SPTSessionDescriptionMessage *_sdpMessage;
}

@property (nonatomic, strong) RTCPeerConnection * peerConnection;
@property (nonatomic, strong) RTCPeerConnectionFactory *factory;

@property (nonatomic, readonly) BOOL isRegisteredWithRoomServer;

@property (nonatomic, strong) NSString *janusHost;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *pluginId;
@property (nonatomic, strong) NSString *roomId;

@property (nonatomic, strong) NSString *clientId;

@property (nonatomic, strong) NSMutableArray *candidatesArray;
@property (nonatomic, strong) NSString *jsepString;

@property(nonatomic, strong) NSMutableArray *iceServers;

@property(nonatomic, strong) NSDictionary * stageUserInfo;

@property(nonatomic, assign) BOOL isSpeakerEnabled;

@end

@implementation SPTJanusStream

@synthesize sessionId = _sessionId;
@synthesize pluginId = _pluginId;
@synthesize roomId = _roomId;
@synthesize iceServers = _iceServers;
@synthesize stageUserInfo = _stageUserInfo;

#pragma mark - Public Methods

- (instancetype)initWithDelegate:(id<SPTJanusStreamDelegate>)delegate url:(NSString *)url {
    if (self = [super init]) {
        _delegate = delegate;
        _factory = [[RTCPeerConnectionFactory alloc] init];
        //        _messageQueue = [NSMutableArray array];
        _iceServers = [NSMutableArray arrayWithObject:[self defaultSTUNServer]];

        _serverHostUrl = url;
        //        _isSpeakerEnabled = YES;
        //        [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                 selector:@selector(orientationChanged:)
        //                                                     name:@"UIDeviceOrientationDidChangeNotification"
        //                                                   object:nil];
        _candidatesArray = [NSMutableArray array];
        //        _isInitiator = NO;
    }
    return self;
}

- (void)connectWithUserInfo:(NSDictionary *)userInfo {
    
    _stageUserInfo = [NSDictionary dictionaryWithDictionary:userInfo];
    //    _isInitiator = initiator;
    NSDictionary * steamDic = userInfo[@"stream"];
    self.streamId = steamDic[@"id"];
    self.janusHost = steamDic[@"host"];
    
    [self requestTurnServers];
}

- (void)dealloc {
//    NSLOG(@"...stream removing...");
    [self disconnect];
}

- (void)disconnect {
    
//    NSLOG(@"...stream removed...");
    
    [self destroy   ];
    
    if (_state == kSPTJanusStreamStateDisconnected) {
        return;
    }
    if (self.isRegisteredWithRoomServer) {
        [self unregisterWithRoomServer];
    }
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
    _roomId = nil;
    //    _isInitiator = NO;
    //    _hasReceivedSdp = NO;
    //    _messageQueue = [NSMutableArray array];
    _peerConnection = nil;
    //    self.state = kSPTJanusClientStateDisconnected;
    
    
}

- (void)destroy {
    
    [self destroyJanusSessionWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
//        NSLOG(@"...session destroyed...");
        _peerConnection = nil;
    }];
}

#pragma mark - Janus Session Methods

- (void)createJanusSessionWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@", self.janusHost];
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
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@", self.janusHost, self.sessionId];
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

- (void)attachJanusPlugin:(NSString *)plugin
          completionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@", self.janusHost, self.sessionId];
    NSString * params = [NSString stringWithFormat: @"{\"janus\":\"attach\", \"plugin\":\"%@\", \"transaction\":\"attach_plugin_streaming\"}", plugin];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
        
        if (completionBlock) {
            completionBlock(dic, error);
        }
    }];
}

- (void)detachJanusPluginWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@/%@", self.janusHost, self.sessionId, self.pluginId];
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

- (void)listenForJanusMessages {
    
    NSString * params = @"...Long Poll GET Request...";
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@", self.janusHost, self.sessionId];
    
    __weak SPTJanusStream * weakSelf = self;
    
    __block void (^weak_apply)(NSInteger);
    void(^apply)(NSInteger);
    weak_apply = apply = ^(NSInteger someInteger){
        
        [self makeGetRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
            
//            dispatch_async(dispatch_get_main_queue(), ^{
                NSError * localError = nil;
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
                
//                NSLOG(@"longpool_streaming_transaction: %@", dic);
            
                BOOL keepAlive = [dic[@"janus"] isEqualToString:@"keepalive"] ? YES : NO;
                if (!keepAlive) [weakSelf handleJanusMessage:dic];
                weak_apply(1);
//            });
        }];
    };
    
    apply(1);
}

- (void)handleJanusMessage:(NSDictionary *)responseDictionary {
    
    NSDictionary *jsep = responseDictionary[@"jsep"];
    if (jsep) {
            [self proceedRemoteJSEP:jsep];        
    }
}

#pragma mark - Janus Streaming Plugin Synchronous Methods

#pragma mark - Janus Streaming Plugin Asynchronous Methods

- (void)roomWatchRequestWithStreamId:(NSString *)streamId
                                 pin:(NSString *)pin {
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@/%@", self.janusHost, self.sessionId, self.pluginId];
    NSString *params = @"";
    
    params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_watch_streaming\", \"body\":{\"request\":\"watch\", \"id\":%@, \"pin\":\"%@\"}}", streamId, pin];
    
    [self makePostRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
        
        NSError * localError = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
        
//        NSLOG(@"%@: %@", dic[@"transaction"], dic);
    }];
}

#pragma mark - Janus Router WebRTC Methods

- (void)startStreamingPlugin:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@/%@", self.janusHost, self.sessionId, self.pluginId];
    
    NSString * params = [NSString stringWithFormat:@"{\"janus\":\"message\", \"transaction\":\"message_answer_streaming\", \"body\":{\"request\":\"start\"}, \"jsep\":%@}", self.jsepString];
    
    typeof(self) __weak weak = self;
    
    [self makePostRequestToURL:urlString withParams:params
               completionBlock:^(id JSON, NSError *error) {
                   
                   NSError * localError = nil;
                   NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON
                                                                        options:0
                                                                          error:&localError];
                   
//                   NSLOG(@"listen result: %@: %@ \njsep: %@", dic[@"transaction"], dic, weak.jsepString);
                   
                   for (SPTICECandidateMessage *message in self.candidatesArray) {
                       [weak trickleCandidate:message];
                   }
                   
                   [weak completeTrickleCandidate];
                   
                   if (completionBlock) {
                       completionBlock(dic, error);
                   }
               }];
}

- (void)trickleCandidate:(SPTICECandidateMessage *)message {
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@/%@", self.janusHost, _sessionId, _pluginId];
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
    
    NSString * urlString = [NSString stringWithFormat:@"https://%@%@/%@", self.janusHost, _sessionId, _pluginId];
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
- (void)peerConnection:(RTCPeerConnection *)peerConnection
 signalingStateChanged:(RTCSignalingState)stateChanged {
//    NSLOG(@"Signaling state changed: %d", stateChanged);
}

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
           addedStream:(RTCMediaStream *)stream {
    //    NSLOG(@"Received %lu video tracks and %lu audio tracks", (unsigned long)stream.videoTracks.count, (unsigned long)stream.audioTracks.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Received %lu video tracks and %lu audio tracks",
              (unsigned long)stream.videoTracks.count,
              (unsigned long)stream.audioTracks.count);
        if (stream.videoTracks.count) {
            RTCVideoTrack *videoTrack = stream.videoTracks[0];
            [_delegate appClient:self didReceiveRemoteVideoTrack:videoTrack];
            //            if (_isSpeakerEnabled) [self enableSpeaker]; //Use the "handsfree" speaker instead of the ear speaker.
        }
    });
}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
         removedStream:(RTCMediaStream *)stream {
//    NSLOG(@"Stream was removed.");
}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection {
//    NSLOG(@"WARNING: Renegotiation needed but unimplemented.");
}

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
  iceConnectionChanged:(RTCICEConnectionState)newState {
//    NSLOG(@"ICE state changed: %d", newState);
}

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
   iceGatheringChanged:(RTCICEGatheringState)newState {
//    NSLOG(@"ICE gathering state changed: %d", newState);
}

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
       gotICECandidate:(RTCICECandidate *)candidate {
//    NSLOG(@"got ICE Candidate: %@", candidate);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SPTICECandidateMessage *message =
        [[SPTICECandidateMessage alloc] initWithCandidate:candidate];
        //        [self sendSignalingMessage:message];
        
        [self.candidatesArray addObject:message];
    });
}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel {
//    NSLOG(@"did Open Data Channel");
}

#pragma mark - RTCSessionDescriptionDelegate Methods

// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp error:(NSError *)error {
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
//        [self sendSignalingMessage:message];
        
        [self startStreamingPlugin:^(NSDictionary *JSONDic, NSError *error) {
        }];
    });
}

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didSetSessionDescriptionWithError:(NSError *)error {
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
        if (!_peerConnection.localDescription) {
            
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

- (void)requestTurnServers {
    
    // Request TURN.
//    NSLOG(@"request turn servers");
    __weak SPTJanusStream *weakSelf = self;
    NSURL *turnRequestURL = [NSURL URLWithString:kSPTTurnRequestUrl];
    [self requestTURNServersWithURL:turnRequestURL
                  completionHandler:^(NSArray *turnServers) {
                      
                      SPTJanusStream *strongSelf = weakSelf;
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
    _peerConnection = [_factory peerConnectionWithICEServers:_iceServers
                                                 constraints:constraints
                                                    delegate:self];
    
//    RTCMediaStream *localStream = [self createLocalMediaStream];
//    [_peerConnection addStream:localStream];
    
//    [self waitForAnswer];
    
    [self initJanusSession];
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
    //    if (_isInitiator) {
    //        [self sendSignalingMessageToRoomServer:message completionHandler:nil];
    //    } else {
    //
    //    }
}

- (void)sendSignalingMessageToRoomServer:(SPTSignalingMessage *)message
                       completionHandler:(void (^)(SPTMessageResponse *))completionHandler {
//    NSData *data = [message JSONData];
    NSString *urlString =
    [NSString stringWithFormat:
     kSPTRoomServerMessageFormat, self.serverHostUrl, _roomId, _clientId];
    NSLog(@"urlStringurlStringurlString: %@", urlString);
//    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"C->RS POST: %@", message);
//    __weak SPTJanusStream *weakSelf = self;
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
//                                      NSLocalizedDescriptionKey: @"Room server network error",
                                      }];
    return error;
}

- (void)unregisterWithRoomServer {
    NSString *urlString =
    [NSString stringWithFormat:kSPTRoomServerByeFormat, self.serverHostUrl, _roomId, _clientId];
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

- (void)initJanusSession {
    
//    NSLOG(@"<--------- Start Janus Streaming Connection --------->");
    
    [self createJanusSessionWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
        NSDictionary * dataDic = JSONDic[@"data"];
        self.sessionId = dataDic[@"id"];
        
        [self attachJanusPlugin:kSPTPluginNameStreaming completionBlock:^(NSDictionary *JSONDic, NSError *error) {
            
            [self listenForJanusMessages];
            
            NSDictionary *pluginDic = JSONDic[@"data"];
            self.pluginId = pluginDic[@"id"];
            NSDictionary * streamInfo = _stageUserInfo[@"stream"];
            [self roomWatchRequestWithStreamId:streamInfo[@"id"]
                                           pin:streamInfo[@"pin"]];
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
    RTCMediaStream* localStream = [_factory mediaStreamWithLabel:@"ARDAMS"];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
//        [_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
    }
    
    [localStream addAudioTrack:[_factory audioTrackWithID:@"ARDAMSa0"]];
    //    if (_isSpeakerEnabled) [self enableSpeaker];
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
                            NSLog(@"Unable to get TURN server.");
                            completionHandler(turnServers);
                            return;
                        }
                        NSDictionary *dict = [NSDictionary dictionaryWithJSONData:data];
                        turnServers = [RTCICEServer serversFromCEODJSONDictionary:dict];
                        completionHandler(turnServers);
                    }];
}

- (void)makeGetRequestToURL:(NSString *)urlString
                 withParams:(NSString*)params
            completionBlock:(void(^)(id JSON, NSError *error))completionBlock {
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
    
//        NSLOG(@"Loading data from Janus: %@%@", urlString, params);
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSData *paramsData = [params dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    //[request setURL:[NSURL URLWithString:urlString]];
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
//                           NSLOG(@"Error loading data:%@\n ", error);
                       }
                   } else {
//                       NSLOG(@"Error loading data:%@\n ", error);
                   }
               }];
    
    [dataTask resume];
}

#pragma mark - NSURLSessionDelegate Methods

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if([challenge.protectionSpace.host isEqualToString:self.janusHost]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
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

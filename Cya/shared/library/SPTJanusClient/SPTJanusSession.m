//
//  SPTJanusSession.m
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-26.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "SPTJanusSession.h"

// TODO(tkchin): move these to a configuration object.
static NSString *kSPTJanusHostUrl =
@"https://room-52-87-230-252.synaptop.com";
static NSString *kSPTJanusSessionHostUrl =
@"https://room-52-87-230-252.synaptop.com/%@";

@implementation SPTJanusSession

#pragma mark - Life Cicle Methods

- (id)initWithDelegate:(id<SPTJanusSessionDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)connectWithError:(NSError**)error {
    
    [self createJanusSessionWithCompletionBlock:^(NSDictionary *JSONDic, NSError *error) {
        
    }];
}

- (void)disconnect:(NSError**)error {
    
}

#pragma mark - Janus Methods

- (void)createJanusSessionWithCompletionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = kSPTJanusHostUrl;
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

- (void)destroyJanusSessionWithId:(NSString *)sessionId completionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
    
    NSString * urlString = [NSString stringWithFormat:kSPTJanusSessionHostUrl, sessionId];
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

//- (void)longpollEventRequestWithSessionId:(NSString *)sessionId pluginId:(NSString *)pluginId  completionBlock:(void(^)(NSDictionary *JSONDic, NSError *error))completionBlock {
//    
//    NSString * urlString = [NSString stringWithFormat:kSPTJanusSessionHostUrl, sessionId];
//    NSString * params = @"...Long Poll GET Request...";
//    
//    __weak SPTJanusSession * weakSelf = self;
//    
//    __block void (^weak_apply)(NSInteger);
//    void(^apply)(NSInteger);
//    weak_apply = apply = ^(NSInteger someInteger){
//        
//        [self makeGetRequestToURL:urlString withParams:params completionBlock:^(id JSON, NSError *error) {
//            
//            NSError * localError = nil;
//            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:&localError];
//            
//            NSLOG(@"longpool_videoroom_transaction: %@", dic);
//            
//            BOOL keepAlive = NO;
//            keepAlive = [dic[@"janus"] isEqualToString:@"keepalive"] ? YES : NO;
//            
//            NSDictionary *jsep = dic[@"jsep"];
//            
//            if (keepAlive) {
//                weak_apply(1);
//            } else {
//                
//                if (jsep) {
//                    
//                    NSDictionary *plugindataDic = dic[@"plugindata"];
//                    NSDictionary *attachedDataDic = plugindataDic[@"data"];
//                    
//                    self.roomIdString = attachedDataDic[@"room"];
//                    
//                    
//#warning we need publisher befor joining room
//                    //                    NSArray *publishersArray = attachedDataDic[@"publishers"];
//                    //                    NSDictionary *firstPublisherDic = [publishersArray objectAtIndex:0];
//                    //                    self.firstPublisherIdString = firstPublisherDic[@"id"];
//                    
//                    [weakSelf proceedRemoteJSEP:jsep];
//                }
//                
//                [weakSelf handleLongPollResponseDictionary:dic];
//                weak_apply(1);
//            }
//        }];
//    };
//    
//    apply(1);
//}

- (void)makeGetRequestToURL:(NSString *)urlString withParams:(NSString*)params completionBlock:(void(^)(id JSON, NSError *error))completionBlock {
    
//    NSLOG(@"Loading data from Janus: %@%@", urlString, params);
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
    
    //    NSData *paramsData = [params dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    //[request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPBody:paramsData];
    
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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
    
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

//- (void)handleLongPollResponseDictionary:(NSDictionary *)responseDictionary {
//    
//    NSString * transactionString = responseDictionary[@"transaction"];
//    
//    if ([transactionString isEqualToString:@"message_join_videoroom"] && ![responseDictionary[@"janus"] isEqualToString:@"ack"]) {
//        if (_isInitiator) {
//            [self initJanusPeerConnectionWithSessionId:self.sessionId pluginId:self.pluginId jsep:self.jsepString completionBlock:^(NSDictionary *JSONDic, NSError *error) {
//                
//            }];
//        } else {
//            
//            
//        }
//    }
//}

#pragma mark - NSURLSessionDelegate Methods

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if([challenge.protectionSpace.host isEqualToString:@"room-52-87-230-252.synaptop.com"]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}

@end

//
//  SPTJanusClient.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-03-29.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libjingle_peerconnection/RTCVideoTrack.h>

typedef NS_ENUM(NSInteger, SPTJanusClientState) {
    // Disconnected from servers.
    kSPTJanusClientStateDisconnected,
    // Connecting to servers.
    kSPTJanusClientStateConnecting,
    // Connected to servers.
    kSPTJanusClientStateConnected,
};

@class SPTJanusClient;
@protocol SPTJanusClientDelegate <NSObject>

- (void)appClient:(SPTJanusClient *)client
   didChangeState:(SPTJanusClientState)state;

- (void)appClient:(SPTJanusClient *)client
didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack;

- (void)appClient:(SPTJanusClient *)client
didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack;

- (void)appClient:(SPTJanusClient *)client
         didError:(NSError *)error;
@end

@interface SPTJanusClient : NSObject

@property(nonatomic, readonly) SPTJanusClientState state;
@property(nonatomic, weak) id<SPTJanusClientDelegate> delegate;
@property(nonatomic, strong) NSString *serverHostUrl;
@property (nonatomic, assign) BOOL isInitiator;
@property (nonatomic, strong) NSString *stageSessionId;

//- (id)init __attribute__((
//                          unavailable("init is not a supported initializer for this class.")));

- (instancetype)initWithDelegate:(id<SPTJanusClientDelegate>)delegate;

- (void)createWebRTCPeerConnectionAsInitiator:(BOOL)initiator
                                     userInfo:(NSDictionary *)userInfo;

- (void)connectWithUserInfo:(NSDictionary *)userInfo;

- (void)disconnect;

- (void)muteAudioIn;
- (void)unmuteAudioIn;
- (void)muteVideoIn;
- (void)unmuteVideoIn;
- (void)swapCameraToFront;
- (void)swapCameraToBack;


@end

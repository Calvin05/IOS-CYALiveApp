//
//  SPTJanusStream.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-05-05.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libjingle_peerconnection/RTCVideoTrack.h>

typedef NS_ENUM(NSInteger, SPTJanusStreamState) {
    // Disconnected from servers.
    kSPTJanusStreamStateDisconnected,
    // Connecting to servers.
    kSPTJanusStreamStateConnecting,
    // Connected to servers.
    kSPTJanusStreamStateConnected,
};

@class SPTJanusStream;
@protocol SPTJanusStreamDelegate <NSObject>

- (void)appClient:(SPTJanusStream *)client
   didChangeState:(SPTJanusStreamState)state;

- (void)appClient:(SPTJanusStream *)client
didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack;

- (void)appClient:(SPTJanusStream *)client
didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack;

- (void)appClient:(SPTJanusStream *)client
         didError:(NSError *)error;

@end

@interface SPTJanusStream : NSObject

@property (nonatomic, strong) NSNumber * streamId;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, readonly) SPTJanusStreamState state;
@property (nonatomic, weak) id<SPTJanusStreamDelegate> delegate;
@property (nonatomic, strong) NSString *serverHostUrl;

@property (nonatomic, strong) RTCVideoTrack * videoTrack;

// -(id)init __attribute__((
// unavailable("init is not a supported initializer for this class.")));

- (instancetype)initWithDelegate:(id<SPTJanusStreamDelegate>)delegate url:(NSString *)url;

- (void)connectWithUserInfo:(NSDictionary *)userInfo;
- (void)disconnect;

- (void)destroy;

@end

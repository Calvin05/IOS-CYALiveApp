//
//  SPTSignalingMessage.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-07.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <libjingle_peerconnection/RTCICECandidate.h>
#import <libjingle_peerconnection/RTCSessionDescription.h>

typedef enum {
    kSPTSignalingMessageTypeCandidate,
    kSPTSignalingMessageTypeOffer,
    kSPTSignalingMessageTypeAnswer,
    kSPTSignalingMessageTypeBye
} SPTSignalingMessageType;

@interface SPTSignalingMessage : NSObject

@property(nonatomic, readonly) SPTSignalingMessageType type;

+ (SPTSignalingMessage *)messageFromJSONString:(NSString *)jsonString;
- (NSData *)JSONData;

@end

@interface SPTICECandidateMessage : SPTSignalingMessage

@property(nonatomic, readonly) RTCICECandidate *candidate;

- (instancetype)initWithCandidate:(RTCICECandidate *)candidate;

@end

@interface SPTSessionDescriptionMessage : SPTSignalingMessage

@property(nonatomic, readonly) RTCSessionDescription *sessionDescription;

- (instancetype)initWithDescription:(RTCSessionDescription *)description;

@end

@interface SPTByeMessage : SPTSignalingMessage

@end
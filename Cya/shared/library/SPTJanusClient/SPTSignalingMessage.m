//
//  SPTSignalingMessage.m
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-07.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "SPTSignalingMessage.h"

#import "SPTUtilities.h"
#import "RTCSessionDescription+JSON.h"
#import "RTCICECandidate+JSON.h"

static NSString const *kSPTSignalingMessageTypeKey = @"type";

@implementation SPTSignalingMessage

@synthesize type = _type;

- (instancetype)initWithType:(SPTSignalingMessageType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

-(NSString *)description {
    return [[NSString alloc]initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

+ (SPTSignalingMessage *)messageFromJSONString:(NSString *)jsonString {
    NSDictionary *values = [NSDictionary dictionaryWithJSONString:jsonString];
    if (!values) {
        NSLog(@"Error parsing signaling message JSON.");
        return nil;
    }
    
    NSString *typeString = values[kSPTSignalingMessageTypeKey];
    SPTSignalingMessage *message = nil;
    if ([typeString isEqualToString:@"candidate"]) {
        RTCICECandidate *candidate =
        [RTCICECandidate candidateFromJSONDictionary:values];
        message = [[SPTICECandidateMessage alloc] initWithCandidate:candidate];
    } else if ([typeString isEqualToString:@"offer"] ||
               [typeString isEqualToString:@"answer"]) {
        RTCSessionDescription *description =
        [RTCSessionDescription descriptionFromJSONDictionary:values];
        message =
        [[SPTSessionDescriptionMessage alloc] initWithDescription:description];
    } else if ([typeString isEqualToString:@"bye"]) {
        message = [[SPTByeMessage alloc] init];
    } else {
        NSLog(@"Unexpected type: %@", typeString);
    }
    return message;
  
    return nil;
}

- (NSData *)JSONData {
    return nil;
}

@end

@implementation SPTICECandidateMessage

@synthesize candidate = _candidate;

- (instancetype)initWithCandidate:(RTCICECandidate *)candidate {
    if (self = [super initWithType:kSPTSignalingMessageTypeCandidate]) {
        _candidate = candidate;
    }
    return self;
}

- (NSData *)JSONData {
//    return [_candidate JSONData];
    
    return nil;
}

@end

@implementation SPTSessionDescriptionMessage

@synthesize sessionDescription = _sessionDescription;

-(instancetype)initWithDescription:(RTCSessionDescription *)description {
    SPTSignalingMessageType type = kSPTSignalingMessageTypeOffer;
    NSString *typeString = description.type;
    if ([typeString isEqualToString:@"offer"]) {
        type = kSPTSignalingMessageTypeOffer;
    } else if ([typeString isEqualToString:@"answer"]) {
        type = kSPTSignalingMessageTypeAnswer;
    } else {
        NSAssert1(NO, @"Unexpected type: %@", typeString);
    }
    self = [super initWithType:type];
    if (self) {
        _sessionDescription = description;
    }
    return self;
}

- (NSData *)JSONData {
    return [_sessionDescription JSONData];
}

@end

@implementation SPTByeMessage

-(instancetype)init {
    return [super initWithType:kSPTSignalingMessageTypeBye];
}

@end
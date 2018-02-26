//
//  RTCSessionDescription+JSON.m
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-11.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "RTCSessionDescription+JSON.h"

static NSString const *kRTCSessionDescriptionTypeKey = @"type";
static NSString const *kRTCSessionDescriptionSdpKey = @"sdp";

@implementation RTCSessionDescription (JSON)

+ (RTCSessionDescription *)descriptionFromJSONDictionary:
(NSDictionary *)dictionary {
    NSString *type = dictionary[kRTCSessionDescriptionTypeKey];
    NSString *sdp = dictionary[kRTCSessionDescriptionSdpKey];
    return [[RTCSessionDescription alloc] initWithType:type sdp:sdp];
}

- (NSData *)JSONData {
    NSDictionary *json = @{
                           kRTCSessionDescriptionTypeKey : self.type,
                           kRTCSessionDescriptionSdpKey : self.description
                           };
    return [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
}

@end

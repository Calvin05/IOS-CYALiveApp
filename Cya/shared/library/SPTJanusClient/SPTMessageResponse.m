//
//  SPTMessageResponse.m
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-07.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "SPTMessageResponse.h"

#import "SPTUtilities.h"

static NSString const *kARDMessageResultKey = @"result";

@interface SPTMessageResponse ()

@property(nonatomic, assign) SPTMessageResponseType result;

@end

@implementation SPTMessageResponse

@synthesize result = _result;

+ (SPTMessageResponse *)responseFromJSONData:(NSData *)data {
    NSDictionary *responseJSON = [NSDictionary dictionaryWithJSONData:data];
    if (!responseJSON) {
        return nil;
    }
    SPTMessageResponse *response = [[SPTMessageResponse alloc] init];
    response.result =
    [[self class] resultTypeFromString:responseJSON[kARDMessageResultKey]];
    return response;
}

#pragma mark - Private

+ (SPTMessageResponseType)resultTypeFromString:(NSString *)resultString {
    SPTMessageResponseType result = kSPTMessageResponseTypeUnknown;
    if ([resultString isEqualToString:@"SUCCESS"]) {
        result = kSPTMessageResponseTypeSuccess;
    } else if ([resultString isEqualToString:@"INVALID_CLIENT"]) {
        result = kSPTMessageResponseTypeInvalidClient;
    } else if ([resultString isEqualToString:@"INVALID_ROOM"]) {
        result = kSPTMessageResponseTypeInvalidRoom;
    }
    return result;
}

@end

//
//  SPTMessageResponse.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-07.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SPTMessageResponseType) {
    kSPTMessageResponseTypeUnknown,
    kSPTMessageResponseTypeSuccess,
    kSPTMessageResponseTypeInvalidRoom,
    kSPTMessageResponseTypeInvalidClient
};

@interface SPTMessageResponse : NSObject

@property(nonatomic, readonly) SPTMessageResponseType result;

+ (SPTMessageResponse *)responseFromJSONData:(NSData *)data;

@end

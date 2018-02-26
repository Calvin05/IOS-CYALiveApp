//
//  RTCSessionDescription+JSON.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-11.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "RTCSessionDescription.h"

@interface RTCSessionDescription (JSON)

+ (RTCSessionDescription *)descriptionFromJSONDictionary:
(NSDictionary *)dictionary;
- (NSData *)JSONData;

@end

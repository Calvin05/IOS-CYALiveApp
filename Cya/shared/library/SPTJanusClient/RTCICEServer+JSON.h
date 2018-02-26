//
//  RTCICEServer+JSON.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-13.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "RTCICEServer.h"

@interface RTCICEServer (JSON)

+ (RTCICEServer *)serverFromJSONDictionary:(NSDictionary *)dictionary;
// CEOD provides different JSON, and this parses that.
+ (NSArray *)serversFromCEODJSONDictionary:(NSDictionary *)dictionary;

@end

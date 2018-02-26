//
//  RTCICECandidate+JSON.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-12.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "RTCICECandidate.h"

@interface RTCICECandidate (JSON)

+ (RTCICECandidate *)candidateFromJSONDictionary:(NSDictionary *)dictionary;
- (NSData *)JSONData;

@end

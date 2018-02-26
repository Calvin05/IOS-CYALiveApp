//
//  SPTJanusPluginHandle.m
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-25.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import "SPTJanusPluginHandle.h"

@implementation SPTJanusPluginHandle

@synthesize type = _type;

- (instancetype)initWithType:(SPTJanusPluginHandleType)type delegate:(id<SPTJanusPluginHandleDelegate>)delegate name:(NSString *)name {
    self = [super init];
    if (self) {
        _type = type;
    }
    
    return self;
}

#pragma mark - Janus Methods



@end

@implementation SPTJanusVideoroomPluginHandle

@end

@implementation SPTJanusStreamingPluginHandle

@end
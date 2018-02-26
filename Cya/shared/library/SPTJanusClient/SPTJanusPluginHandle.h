//
//  SPTJanusPluginHandle.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-25.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, SPTJanusPluginHandleType) {
    SPTJanusPluginHandleTypePublisher,
    SPTJanusPluginHandleTypeListener
};

@protocol SPTJanusPluginHandleDelegate <NSObject>



@end

@interface SPTJanusPluginHandle : NSObject

@property (nonatomic, readonly) SPTJanusPluginHandleType type;
@property (nonatomic, readonly) id<SPTJanusPluginHandleDelegate> delegate;
@property (nonatomic, readonly) NSString *name;

@end

@interface SPTJanusVideoroomPluginHandle : SPTJanusPluginHandle

@end

@interface SPTJanusStreamingPluginHandle : SPTJanusPluginHandle

@end

//
//  SPTJanusSession.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-26.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPTJanusSession, SPTJanusPluginHandle;

@protocol SPTJanusSessionDelegate <NSObject>

- (void)sessionDidConnect:(SPTJanusSession*)session;

- (void)sessionDidDisconnect:(SPTJanusSession*)session;

- (void)session:(SPTJanusSession*)session didFailWithError:(NSError*)error;

- (void)session:(SPTJanusSession*)session streamCreated:(SPTJanusPluginHandle*)stream;

- (void)session:(SPTJanusSession*)session streamDestroyed:(SPTJanusPluginHandle*)stream;

@optional

- (void)session:(SPTJanusSession*)session
receivedSignalType:(NSString*)type
    fromConnection:(NSDictionary*)connection
        withString:(NSString*)string;

@end

@interface SPTJanusSession : NSObject <NSURLSessionDelegate>

/**
 * The [Session ID]
 * of this instance. This is an immutable value.
 */
@property(readonly) NSString* sessionId;

/**
 * The plugins that are a part of this session, keyed by pluginId.
 */
@property(readonly) NSDictionary* plugins;

/**
 * The <SPTJanusSessionDelegate> object that serves as a delegate object for this
 * SPTJanusSession object,
 * handling messages on behalf of this session.
 */
@property(nonatomic, assign) id<SPTJanusSessionDelegate> delegate;

/** @name Initializing and connecting to a session */

/**
 * Initialize this session with a delegate before connecting to Janus. Send the
 * <[SPTJanusSession connectWithToken:error:]> message
 * to connect to the session.
 *
 * @param delegate The delegate (SPTJanusSessionDelegate) that handles messages on
 * behalf of this session.
 *
 * @return The SPTJanusSession object, or nil if initialization fails.
 */
- (id)initWithDelegate:(id<SPTJanusSessionDelegate>)delegate;

- (void)connectWithError:(NSError**)error;

- (void)disconnect:(NSError**)error;



@end

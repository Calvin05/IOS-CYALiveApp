//
//  SPTUtilities.h
//  Synaparty
//
//  Created by Mykola Burynok on 16-04-07.
//  Copyright © 2016 Mykola Burynok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SPTUtilities)

// Creates a dictionary with the keys and values in the JSON object.
+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString;
+ (NSDictionary *)dictionaryWithJSONData:(NSData *)jsonData;

@end

@interface NSURLConnection (SPTUtilities)

// Issues an asynchronous request that calls back on main queue.
+ (void)sendAsyncRequest:(NSURLRequest *)request
       completionHandler:(void (^)(NSURLResponse *response,
                                   NSData *data,
                                   NSError *error))completionHandler;

// Posts data to the specified URL.
+ (void)sendAsyncPostToURL:(NSURL *)url
                  withData:(NSData *)data
         completionHandler:(void (^)(BOOL succeeded,
                                     NSData *data))completionHandler;

@end

//
//  GBServerManager.h
//  MedNews
//
//  Created by George Bakaykin on 05/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBServerManager : NSObject

+ (GBServerManager* )sharedManager;

- (void) getDataWithRequest:(NSString*) urlRequest
                  andParams:(NSDictionary* )params
                  OnSuccess:(void(^)(NSArray* data)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getDetailForObject:(id) obj
             withRequest:(NSString*) urlRequest
                  OnSuccess:(void(^)(id obj)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;
@end

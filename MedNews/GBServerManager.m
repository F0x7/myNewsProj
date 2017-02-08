//
//  GBServerManager.m
//  MedNews
//
//  Created by George Bakaykin on 05/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import "GBServerManager.h"
#import "AFNetworking.h"
#import "GBNews.h"

static NSString* const accsessToken = @"tPK7s7vdmDxZf7Ar";
static NSURL* baseURL;

@implementation GBServerManager

+ (GBServerManager* )sharedManager {
    
    static GBServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GBServerManager alloc] init];
        baseURL = [[NSURL alloc] initWithString:@"http://news.mhth.ru"];

    });
    return manager;
}

- (void) getDataWithRequest:(NSString *)urlRequest
                  andParams:(NSDictionary *)params
                  OnSuccess:(void (^)(NSArray * news))success
                  onFailure:(void (^)(NSError *, NSInteger))failure {
        
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:baseURL];
    [manager.requestSerializer setValue: accsessToken forHTTPHeaderField:@"X-Token"];
    
    [manager GET:urlRequest
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             
             NSArray* newsArray = [responseObject valueForKey:@"data"];
             NSMutableArray* objectsArray = [NSMutableArray array];
             
             for (NSDictionary* dict in newsArray) {
                 // creating objects and initialization in constructor with dictionary
                 GBNews* news = [[GBNews alloc] initWithServerResponse:dict];
                 [objectsArray addObject:news];
             }
             
             if (success) {
                 success(objectsArray);
                 responseObject = nil;
             }

      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failure) {
              
              NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)task.response;
              failure(error, httpResponse.statusCode);
          }
          
      }];
}

- (void) getDetailForObject:(id)obj
                withRequest:(NSString *)urlRequest
                  OnSuccess:(void (^)(id))success
                  onFailure:(void (^)(NSError *, NSInteger))failure {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:baseURL];
    [manager.requestSerializer setValue: accsessToken forHTTPHeaderField:@"X-Token"];
    
    [manager GET:urlRequest
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             
             if ([obj isKindOfClass:[GBNews class]]) {
                 GBNews* news =news = obj;
                 
                 //add detail data
                 [news addDetailsWithServerResponse:responseObject];
                 
                 if (success) {
                     success(news);
                 }
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 
                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)task.response;
                 failure(error, httpResponse.statusCode);
             }
         }];
}

@end

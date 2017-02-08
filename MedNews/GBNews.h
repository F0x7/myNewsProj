//
//  GBNews.h
//  MedNews
//
//  Created by George Bakaykin on 05/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBNews : NSObject

@property (strong, nonatomic) NSDate* createdAt;
@property (strong, nonatomic) NSString* descriptionPhoto;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* thumbnailURL;
@property (strong, nonatomic) NSString* title;

@property (strong, nonatomic) NSURL* sourceURL;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* lead;

@property (strong, nonatomic) NSArray* spotlight;

- (id) initWithServerResponse:(NSDictionary *) responseObj;
- (void) addDetailsWithServerResponse:(NSDictionary *) responseObj;

@end

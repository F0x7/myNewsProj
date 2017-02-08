//
//  GBNews.m
//  MedNews
//
//  Created by George Bakaykin on 05/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import "GBNews.h"

@implementation GBNews

- (id) initWithServerResponse:(NSDictionary *)responseObj {
    self = [super init];
    if (self) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSZZZ"];
        
        self.createdAt = [dateFormatter dateFromString:[responseObj objectForKey:@"created_at"]];
        self.descriptionPhoto = [responseObj objectForKey:@"description"];
        self.id = [[responseObj objectForKey:@"id"] intValue];
        self.imageURL = [[NSURL alloc] initWithString:[responseObj objectForKey:@"image"]];
        self.thumbnailURL = [[NSURL alloc] initWithString:[responseObj objectForKey:@"thumbnail"]];
        self.title = [responseObj objectForKey:@"title"];
    }
    return self;
}

- (void) addDetailsWithServerResponse:(NSDictionary *)responseObj {
    NSDictionary* data = [responseObj objectForKey:@"data"];
    
    self.lead = [data objectForKey:@"lead"];
    self.sourceURL = [[NSURL alloc] initWithString:[data objectForKey:@"source"]];
    self.text = [data objectForKey:@"text"];
    
    NSArray* spotlight = [responseObj objectForKey:@"spotlight"];
    NSMutableArray* objectsArray = [NSMutableArray array];
    
    for (NSDictionary* dict in spotlight){
        GBNews* news = [[GBNews alloc]initWithServerResponse:dict];
        [objectsArray addObject:news];
    }
    
    self.spotlight = [NSArray arrayWithArray:objectsArray];
}

@end

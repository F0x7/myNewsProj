//
//  GBNewsList.m
//  MedNews
//
//  Created by George Bakaykin on 05/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import "GBNewsList.h"
#import "GBServerManager.h"
#import "GBNews.h"
#import "GBNewsCell.h"
#import "GBDetailNews.h"

#import "UIImageView+AFNetworking.h"

@interface GBNewsList ()

@property (strong, nonatomic) NSMutableArray* newsArray;

@property (assign, nonatomic) NSInteger pageCounter;
@property (assign, nonatomic) NSInteger newsLimitOnPage;
@property (assign, nonatomic) NSInteger fontChangingCounter;

@end

@implementation GBNewsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageCounter = 1;
    self.fontChangingCounter = 1;
    self.newsArray = [NSMutableArray array];
    
    [self getDataFromServerWithPage:[NSNumber numberWithInteger:self.pageCounter]
                           andLimit:[NSNumber numberWithInteger:self.newsLimitOnPage]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

// getting  objects array
-(void) getDataFromServerWithPage:(NSNumber*) page andLimit:(NSNumber*) limit{
    
    NSString* request = @"/api/v1/news?";
    NSDictionary* params = @{@"page" : page, @"limit" : limit};
    
    [[GBServerManager sharedManager] getDataWithRequest:request
                                              andParams:params
                                              OnSuccess:^(NSArray *data) {
                                                                                                
                                                  [self.newsArray addObjectsFromArray:data];
                                                  [self.tableView reloadData];
                                              }
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"Error = %@, code = %ld", [error localizedDescription], (long)statusCode);
                                              }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.newsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    GBNews* news = [self.newsArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd MMM yyyy, hh:mm"];
    NSString *timeString = [formatter stringFromDate:news.createdAt];
    
    cell.descriptionLable.text = news.title;
    cell.dateLable.text = timeString;
    cell.dateLable.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    [cell.imageViewOutlet setImageWithURL:news.thumbnailURL];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *) tableView
   willDisplayCell:(nonnull UITableViewCell *)cell
 forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // get total rows in that section by current indexPath
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        self.pageCounter++;
        [self getDataFromServerWithPage:[NSNumber numberWithInteger:self.pageCounter]
                               andLimit:[NSNumber numberWithInteger: self.newsLimitOnPage]];
    }
}

#pragma mark - Actions

- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    
    self.pageCounter = 1;
    [self.newsArray removeAllObjects];
    
    // refresh with animations
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    [self getDataFromServerWithPage:[NSNumber numberWithInteger:self.pageCounter]
                           andLimit:[NSNumber numberWithInteger:self.newsLimitOnPage]];
    [self.tableView endUpdates];
}

#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Action"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        GBNews* news = [self.newsArray objectAtIndex:indexPath.row];
        
        GBDetailNews *vc = segue.destinationViewController;
        [vc setNews:news];
    }
}

@end

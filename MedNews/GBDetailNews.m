//
//  GBDetailNews.m
//  MedNews
//
//  Created by George Bakaykin on 06/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import "GBDetailNews.h"
#import "GBServerManager.h"
#import "GBNews.h"

#import "GBNewsCell.h"
#import "GBDetailHeaderCell.h"
#import "GBDescriptionCell.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UINavigationBar+Awesome.h"

#define NAVBAR_CHANGE_POINT 50

@interface GBDetailNews ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOutlet;
@property (assign, nonatomic) NSInteger fontChangeCounter;

@end



@implementation GBDetailNews

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //using LTNavigationBar lib for animations
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [self getDetailInfoForNews:self.news];
    
    [self.imageViewOutlet setImageWithURL:self.news.imageURL];
    
    // set gradient to image
    CAGradientLayer *gradient = [self getGradientForImageView:self.imageViewOutlet];
    [self.imageViewOutlet.layer insertSublayer:gradient atIndex:0];
    
    self.fontChangeCounter = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.navigationController.navigationBar lt_reset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:0.07 green:0.71 blue:0.77 alpha:1.0];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark - API

// getting detail parameters for news object with request
-(void) getDetailInfoForNews:(GBNews *) news{
    
    NSString* request = [NSString stringWithFormat:@"/api/v1/news/id=%d", news.id];

    [[GBServerManager sharedManager] getDetailForObject:news
                                            withRequest:request
                                              OnSuccess:^(id obj) {
                                                  if ([obj isKindOfClass:[GBNews class]]) {
                                                      self.news = obj;
                                                      [self.tableView reloadData];
                                                  }
    }
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"Error = %@, code = %ld", [error localizedDescription], (long)statusCode);
                                              }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.news.spotlight count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        GBDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailHeaderCell" forIndexPath:indexPath];
        
        // set first cell here
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"dd MMM yyyy"];
        
        cell.headerLable.text = self.news.title;
        cell.dateLable.text = [formater stringFromDate:self.news.createdAt];
        cell.dateLable.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        
        return cell;
        
    } else if (indexPath.row == 1){
        
        // set second cell here
        GBDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailDescriptionCell" forIndexPath:indexPath];
        cell.textViewOutlet.text = self.news.text;
        cell.fotoInfoLable.text = self.news.descriptionPhoto;
        cell.fotoInfoLable.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        cell.urlLable.text = [NSString stringWithContentsOfURL:self.news.sourceURL encoding:NSUTF8StringEncoding error:nil];
        
        return cell;
        
    } else {
        
        // last cells
        GBNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        GBNews* news = [self.news.spotlight objectAtIndex:indexPath.row - 2];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd MMM yyyy, hh:mm"];
        NSString *timeString = [formatter stringFromDate:news.createdAt];
        
        cell.descriptionLable.text = news.title;
        cell.dateLable.text = timeString;
        [cell.imageViewOutlet setImageWithURL:news.thumbnailURL];
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.estimatedRowHeight = 400.0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >=2) {
     
        GBNews* news = [self.news.spotlight objectAtIndex:indexPath.row - 2];
        
        [self getDetailInfoForNews:news];
        
        self.news = news;
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
        [self.tableView endUpdates];
        
    }
}

#pragma mark - Actions

- (IBAction)backButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)typeSizeButtonAction:(UIBarButtonItem *)sender {
    
}

#pragma mark - Support methods

- (CAGradientLayer *) getGradientForImageView:(UIImageView *) imageView {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = imageView.frame;
    
    // Add colors to layer
    UIColor *startColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIColor *midColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UIColor *endColor = [UIColor clearColor];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[startColor CGColor],
                       (id)[midColor CGColor],
                       (id)[endColor CGColor],
                       nil];
    return gradient;
}

@end

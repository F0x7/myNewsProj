//
//  GBNewsCell.h
//  MedNews
//
//  Created by George Bakaykin on 05/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOutlet;

@end

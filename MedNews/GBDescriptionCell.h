//
//  GBDescriptionCell.h
//  MedNews
//
//  Created by George Bakaykin on 07/02/2017.
//  Copyright © 2017 Egor Bakaykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textViewOutlet;
@property (weak, nonatomic) IBOutlet UILabel *fotoInfoLable;
@property (weak, nonatomic) IBOutlet UILabel *urlLable;

@end

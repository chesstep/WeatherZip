//
//  WZSummaryCell.h
//  WeatherZip
//
//  Created by Chesley Stephens on 1/31/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

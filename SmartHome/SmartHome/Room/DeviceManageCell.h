//
//  DeviceManageCell.h
//  SmartHome
//
//  Created by Oliver on 15/3/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceManageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)configThumbImageView:(NSString *)imageName descriptionLabel:(NSString *)descriptionText;

@end

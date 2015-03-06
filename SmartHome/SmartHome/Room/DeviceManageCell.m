//
//  DeviceManageCell.m
//  SmartHome
//
//  Created by Oliver on 15/3/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "DeviceManageCell.h"

@implementation DeviceManageCell

- (void)awakeFromNib {
    self.containerView.layer.borderColor = [UIColor blueColor].CGColor;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.cornerRadius = 5;
}

- (void)configThumbImageView:(NSString *)imageName descriptionLabel:(NSString *)descriptionText
{
    self.thumbImageView.image = [UIImage imageNamed:imageName];
    self.descriptionLabel.text = descriptionText;
}

@end

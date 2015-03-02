//
//  GridView.h
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchObject.h"

@interface GridView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic, strong) SwitchObject *switchObj;

+ (GridView *)getNibInstance;

@end

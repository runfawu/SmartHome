//
//  GridView.m
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "GridView.h"
#import "Comon.h"

@implementation GridView

- (void)awakeFromNib
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTheSwitch:)];
    longPress.minimumPressDuration = 0.8;
    [self addGestureRecognizer:longPress];
}

+ (GridView *)getNibInstance
{
    NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"GridView" owner:self options:nil];
    
    GridView *instance = nibsArray[0];
    instance.userInteractionEnabled = YES;
    instance.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    instance.layer.borderWidth = 1;
    
    return instance;
}

- (void)longPressTheSwitch:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.onOffFlag = !self.onOffFlag;
    self.switchObj.switchFlag = self.onOffFlag;
    if (self.tag == kGridOfAddDeviceTag && self.delegate && [self.delegate respondsToSelector:@selector(gridViewAddSwitch:)]) {
        [self.delegate gridViewAddSwitch:self];
    }
}

- (void)setOnOffFlag:(BOOL)onOffFlag
{
    _onOffFlag = onOffFlag;
    
    if (onOffFlag) {
        self.thumbnailImageView.backgroundColor = [UIColor redColor];
    } else {
        self.thumbnailImageView.backgroundColor = [UIColor orangeColor];
    }
    
    if (self.tag == -101) { // “添加设备”这个格子
       self.thumbnailImageView.backgroundColor = [UIColor clearColor];
    }
}

@end

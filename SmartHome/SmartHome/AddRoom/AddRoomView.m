//
//  AddView.m
//
//  Created by Tech3 on 15/3/3.
//  Copyright (c) 2015年 Tech3. All rights reserved.
//

#import "AddRoomView.h"

@implementation AddRoomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (instancetype)loadNib
{
    NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"AddRoomView" owner:self options:nil];
    AddRoomView *instance = nibsArray[0];
    return instance;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

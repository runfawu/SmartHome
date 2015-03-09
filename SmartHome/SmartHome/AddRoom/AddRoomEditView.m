//
//  EditView.m
//
//  Created by Tech3 on 15/3/3.
//  Copyright (c) 2015年 Tech3. All rights reserved.
//

#import "AddRoomEditView.h"

@implementation AddRoomEditView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (instancetype)loadEditNib
{
    NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"AddRoomEditView" owner:self options:nil];
    AddRoomEditView *instance = nibsArray[0];
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

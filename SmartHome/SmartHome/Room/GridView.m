//
//  GridView.m
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "GridView.h"

@implementation GridView

+ (GridView *)getNibInstance
{
    NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"GridView" owner:self options:nil];
    GridView *instance = nibsArray[0];
    instance.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    instance.layer.borderWidth = 1;
    
    return instance;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击gridView");
}

@end

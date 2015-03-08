//
//  AddObject.m

//  Created by Tech3 on 15/3/2.
//  Copyright (c) 2015年 Tech3. All rights reserved.
//

#import "AddObject.h"

@implementation AddObject

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (NSMutableArray *)getAddObects
{
    //模拟后台 字典的数组
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    NSMutableArray *addArr = [[NSMutableArray alloc]initWithObjects:@"2.png", @"3.png",@"4.png",@"5.png",nil];
    NSMutableArray *nameArr = [[NSMutableArray alloc]initWithObjects:@"房间", @"开灯",@"开门",@"关灯",nil];
    for (int i = 0; i < addArr.count; i ++) {
        NSMutableDictionary *contentDic = [[NSMutableDictionary alloc]init];
        [contentDic setObject:addArr[i] forKey:@"pic"];
        [contentDic setObject:nameArr[i] forKey:@"name"];
        [dataArr addObject:contentDic];
    }
    return dataArr;
}

@end

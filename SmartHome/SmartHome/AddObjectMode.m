//
//  AddObjectMode.m

//  Created by Tech3 on 15/3/3.
//  Copyright (c) 2015年 Tech3. All rights reserved.
//

#import "AddObjectMode.h"
#import "AddObjectItem.h"

@implementation AddObjectMode

- (NSMutableDictionary *)parseAddArray:(NSArray *)addArray
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    int i = 0;
    for (NSDictionary *dic in addArray) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        AddObjectItem *item = [[AddObjectItem alloc]init];
        item.picStr = [dic objectForKey:@"pic"];
        item.nameStr = [dic objectForKey:@"name"];
        [dict setObject:item forKey:key];
        i ++;
    }
    return dict;
}
@end

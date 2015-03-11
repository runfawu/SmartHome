//
//  SwitchEntity.h
//  SmartHome
//
//  Created by Oliver on 15/3/10.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SwitchEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isOn;
@property (nonatomic, retain) NSNumber * roomID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSData * roomImageData;
@property (nonatomic, retain) NSString * code;

@end

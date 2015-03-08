//
//  RoomSettingViewController.h
//  SmartHome
//
//  Created by micheal on 15/3/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSettingViewController : UIViewController

@property (nonatomic,strong) IBOutlet UICollectionView *roomCollectionView;

//@property (nonatomic,strong) IBOutlet UIView *boundView;

@property (nonatomic,assign) int cols;
@property (nonatomic,assign) int dataNums;

-(void)addRoom;
-(void)deleteRoom;


@end

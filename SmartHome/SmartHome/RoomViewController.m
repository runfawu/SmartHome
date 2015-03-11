//
//  FirstViewController.m
//  SmartHome
//
//  Created by micheal on 15/1/27.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomFirstLevelController.h"
#import "Comon.h"
#import "DeviceManageController.h"
#import "RoomManageController.h"

@interface RoomViewController ()<RoomFirstLevelDelegate>

@property (nonatomic, strong) RoomFirstLevelController *roomFirstLevelController;

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubviewToScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Test
- (void)addSubviewToScrollView // iPhone5S模拟器，坐标莫名其妙
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.roomScrollView.pagingEnabled = YES;
    self.roomScrollView.showsHorizontalScrollIndicator = NO;
    self.roomScrollView.showsVerticalScrollIndicator = NO;
    
    NSLog(@"%@.view.frame = %@", NSStringFromClass([self class]), NSStringFromCGRect(self.view.frame));
    
    self.roomFirstLevelController = [[RoomFirstLevelController alloc] initWithNibName:@"RoomFirstLevelController" bundle:nil];
    self.roomFirstLevelController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNaviHeight - kTabBarHeight - 88); // 得减88 ???
    self.roomFirstLevelController.delegate = self;
    [self.roomScrollView addSubview:self.roomFirstLevelController.view];
    
    NSLog(@"first level frame = %@", NSStringFromCGRect(self.roomFirstLevelController.view.frame));
    NSLog(@"first tableView height = %.2f", self.roomFirstLevelController.view.frame.size.height - 200);
    
    self.roomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kNaviHeight - kTabBarHeight);
}

#pragma mark - RoomFirstLevelDelegate
- (void)roomFirstLevelControllerAddSwitch:(RoomFirstLevelController *)aController
{
    DeviceManageController *deviceManageController = [[DeviceManageController alloc] initWithNibName:@"DeviceManageController" bundle:nil];
    deviceManageController.roomID = aController.roomID;
    deviceManageController.roomImageData = aController.roomImageData;
    deviceManageController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:deviceManageController animated:YES];
}

- (void)roomFirstLevelControllerLongPress:(RoomFirstLevelController *)aController
{
    RoomManageController *roomManageController = [[RoomManageController alloc] initWithNibName:@"RoomManageController" bundle:nil];
    roomManageController.hidesBottomBarWhenPushed = YES;
//roomManageController.switchEntity =
    [self.navigationController pushViewController:roomManageController animated:YES];
}

@end

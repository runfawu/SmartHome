//
//  FirstViewController.m
//  SmartHome
//
//  Created by micheal on 15/1/27.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomFirstLevelController.h"

@interface RoomViewController ()

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
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define kNaviHeight      64
#define kTabBarHeight    49
- (void)addSubviewToScrollView // iPhone5S模拟器，坐标莫名其妙
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.roomScrollView.pagingEnabled = YES;
    self.roomScrollView.showsHorizontalScrollIndicator = NO;
    self.roomScrollView.showsVerticalScrollIndicator = NO;
    
    NSLog(@"%@.view.frame = %@", NSStringFromClass([self class]), NSStringFromCGRect(self.view.frame));
    
    self.roomFirstLevelController = [[RoomFirstLevelController alloc] initWithNibName:@"RoomFirstLevelController" bundle:nil];
    self.roomFirstLevelController.view.frame = CGRectMake(0, 0, 320, 568 - kNaviHeight - kTabBarHeight - 88);
    [self.roomScrollView addSubview:self.roomFirstLevelController.view];
    
    self.roomScrollView.contentSize = CGSizeMake(320, 568 - kNaviHeight - kTabBarHeight);
}

@end

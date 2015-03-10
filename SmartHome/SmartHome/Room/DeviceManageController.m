//
//  DeviceManageController.m
//  SmartHome
//
//  Created by Oliver on 15/3/3.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "DeviceManageController.h"
#import "DeviceManageCell.h"
#import "ConnectNetController.h"
#import "DeviceAddController.h"
#import "ScanViewController.h"

@interface DeviceManageController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *aTableView;
@property (nonatomic, strong) NSArray *thumbImageArray;
@property (nonatomic, strong) NSArray *descriptionTextArray;

@end

@implementation DeviceManageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设备管理";
    [self setup];
}

- (void)setup
{
    self.thumbImageArray = @[@"first", @"first", @"first"];
    self.descriptionTextArray = @[@"设备地址配置", @"二维码扫描", @"网络搜索"];
    
    [self.aTableView registerNib:[UINib nibWithNibName:@"DeviceManageCell" bundle:nil] forCellReuseIdentifier:@"DeviceManageCell"];
}

#pragma mark - TableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DeviceManageCell";
    DeviceManageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell configThumbImageView:self.thumbImageArray[indexPath.row] descriptionLabel:self.descriptionTextArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {  // 一键联网
//        ConnectNetController *connnetController = [[ConnectNetController alloc] initWithNibName:@"ConnectNetController" bundle:nil];
//        [self.navigationController pushViewController:connnetController animated:YES];
        DeviceAddController *deviceAddController = [[DeviceAddController alloc] initWithNibName:@"DeviceAddController" bundle:nil];
        [self.navigationController pushViewController:deviceAddController animated:YES];
        
    } else if (indexPath.row == 1) {
        ScanViewController *scanController = [[ScanViewController alloc] init];
        [self.navigationController pushViewController:scanController animated:YES];

    } else if (indexPath.row == 2) {
        
    }
}

@end

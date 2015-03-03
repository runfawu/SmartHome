//
//  AddHostViewController.m
//  SmartHome
//
//  Created by micheal on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "AddHostViewController.h"

@interface AddHostViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.linkedView.layer.cornerRadius=8.0;
    self.linkedView.layer.borderColor=[UIColor grayColor].CGColor;
    self.linkedView.layer.borderWidth=1;
    
    self.hostTableView.layer.cornerRadius=8.0;
    self.hostTableView.layer.borderWidth=1.0;
    self.hostTableView.layer.borderColor=[UIColor grayColor].CGColor;
    
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

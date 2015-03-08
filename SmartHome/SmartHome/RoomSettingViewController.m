//
//  RoomSettingViewController.m
//  SmartHome
//
//  Created by micheal on 15/3/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "RoomSettingViewController.h"
#import "RoomSettingCollectionViewCell.h"
#import "AppDelegate.h"
#import "AddRoom.h"

@interface RoomSettingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation RoomSettingViewController

@synthesize roomCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cols=3;
    self.dataNums=4;
    // Do any additional setup after loading the view.
}

//每行几列
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataNums;
}

//定义每个cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float s_w = [[UIScreen mainScreen] bounds].size.width;
    return CGSizeMake( (s_w - self.cols*2*5)/self.cols , 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    if (indexPath.row == self.dataNums-1) {
    //        static NSString * CellIdentifier = @"addNewCell";
    //        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //    }else{
    static NSString * CellIdentifier = @"homeCell";
    RoomSettingCollectionViewCell * cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (indexPath.row==0) {
        cell.roomName.text=@"卧室";
    }else if(indexPath.row==1){
        cell.roomName.text=@"客厅";
    }else if (indexPath.row==2){
        cell.roomName.text=@"厨房";
    }else if(indexPath.row==self.dataNums-1){
        cell.roomImageView.image=[UIImage imageNamed:@"add_room"];
        cell.roomName.text=@"添加房间";
    }
//    UILongPressGestureRecognizer *longGes=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteView)];
//    longGes.minimumPressDuration=0.5;
//    [cell addGestureRecognizer:longGes];
    
//    UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
//    [titleLabel sizeToFit];
//    
//    CALayer *layer = [titleLabel layer];
//    
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
//    bottomBorder.borderWidth = 1;
//    bottomBorder.frame = CGRectMake(-1, -1, layer.frame.size.width, 1);
//    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
//    [layer addSublayer:bottomBorder];
//    
//    if(indexPath.row==self.dataNums-1){
//        titleLabel.text=@"添加房间";
//    }
    //    }
    
    return cell;
}

//添加房间用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.row==self.dataNums-1) {
        NSLog(@"current row:%d  section:%d",indexPat.row,indexPat.section);
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddRoom" owner:self options:nil];
        AddRoom *tmpCustomView = [nib objectAtIndex:0];
        tmpCustomView.bgView.layer.cornerRadius=8.0;
        tmpCustomView.bgView.backgroundColor=[UIColor clearColor];
        
//        
        CGRect tmpFrame = [[UIScreen mainScreen] bounds];
        tmpCustomView.frame=tmpFrame;
        
        UIWindow* mainWindow = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).window;
        [mainWindow addSubview:tmpCustomView];
//        [self.navigationController.view addSubview:tmpCustomView];
        
    }else{
       
        
    }
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

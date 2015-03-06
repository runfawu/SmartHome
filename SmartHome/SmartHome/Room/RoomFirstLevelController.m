//
//  RoomFirstLevelController.m
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "RoomFirstLevelController.h"
#import "GridView.h"
#import "Comon.h"
#import "SwitchObject.h"
#import "DeviceManageController.h"

#define kGridViewTag         101
#define kColumn              3
#define kGridWidth           SCREEN_WIDTH / kColumn
#define kGridHeight          kGridWidth

@interface RoomFirstLevelController ()<UITableViewDataSource,
                                       UITableViewDelegate,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate,
                                       GridViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UITableView *aTableView;
@property (nonatomic, strong) NSMutableArray *switchArray;

@end

@implementation RoomFirstLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self addTapToImageView];
}

#pragma mark - Private methods
- (void)setup
{
    self.aTableView.backgroundColor = [UIColor purpleColor];
    self.switchArray = [NSMutableArray array];
    
    //初始化开关格子数据, 默认有 添加设备 这个按钮
    SwitchObject *object = [[SwitchObject alloc] init];
    object.switchName = @"添加设备";
    object.switchImageName = @"main_add";
    [self.switchArray addObject:object];
    
    /*
    for (int i = 0; i < 20; i ++) {
        SwitchObject *object = [[SwitchObject alloc] init];
        object.switchName = [NSString stringWithFormat:@"开关%02d",i + 1];
        object.switchFlag = NO;
        
        [self.switchArray addObject:object];
    }
     */
    
    
}

#pragma mark - Tap image
- (void)addTapToImageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageThumbnailImage:)];
    
    [self.thumbnailImageView addGestureRecognizer:tap];
}

- (void)chageThumbnailImage:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    //[picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.thumbnailImageView.image = info[UIImagePickerControllerEditedImage];
    // TODO: 图片数据写进数据库
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int value = self.switchArray.count % kColumn > 0 ? 1 : 0;
    int line = (int)self.switchArray.count / kColumn + value;
    
    return line * kGridHeight + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SwitchCell";
    
    NSLog(@"xxxxx tableView frame = %@", NSStringFromCGRect(self.aTableView.frame));
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
        
    CGFloat contextWidth = SCREEN_WIDTH;
    CGFloat contextHeight = ((self.switchArray.count-1)/kColumn + 1 ) * kGridHeight;
    CGFloat xGap = (contextWidth - kColumn * kGridWidth) / (kColumn + 1);
    CGFloat yGap = (contextHeight - ((self.switchArray.count-1)/kColumn + 1) * kGridHeight) / ((self.switchArray.count-1)/kColumn + 2);
    
    for (int i = 0; i < self.switchArray.count; i ++) {
        CGFloat X = xGap + i % kColumn * (kGridWidth + xGap);
        CGFloat Y = yGap + i / kColumn * (kGridHeight + yGap);
        
        SwitchObject *object = self.switchArray[i];
        
        GridView *gridView = [GridView getNibInstance];
        gridView.frame = CGRectMake(X, Y, kGridWidth, kGridHeight);
        gridView.tag = kGridViewTag + i;
        gridView.stateLabel.text = object.switchName;
        gridView.thumbnailImageView.image = [UIImage imageNamed:object.switchImageName];
        
        if (i == self.switchArray.count - 1) { // 添加设备 格子
            gridView.tag = kGridOfAddDeviceTag;
            gridView.delegate = self;
        } else {
            
        }
        
        [cell.contentView addSubview:gridView];
    }
    
    
    return cell;
}

#pragma mark - GridViewDelegate
- (void)gridViewAddSwitch:(GridView *)gridView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomFirstLevelControllerAddSwitch:)]) {
        [self.delegate roomFirstLevelControllerAddSwitch:self];
    }
    
}


@end

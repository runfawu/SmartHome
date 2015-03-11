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
#import "AppDelegate.h"
#import "SwitchEntity.h"

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
    
    // TODO: remove observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchDataFromCoreData) name:@"reloadSwitchData" object:nil];
    
    [self setup];
    [self addTapToImageView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
    NSParameterAssert(self.roomImageData.length != 0);
}

#pragma mark - Private methods
- (void)setup
{
    self.roomID = 100; // TODO: 记得修改roomID
    //self.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
    self.aTableView.backgroundColor = [UIColor purpleColor];
    self.switchArray = [NSMutableArray array];
    
    [self fetchDataFromCoreData];
    [self configRoomImage];
}

- (void)fetchDataFromCoreData
{
    [self.switchArray removeAllObjects];
    
    NSManagedObjectContext *context = APP_DELEGATE.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SwitchEntity"];
    request.predicate = [NSPredicate predicateWithFormat:@"roomID == %@", [NSNumber numberWithInteger:self.roomID]];
    
    NSArray *switchArray = [context executeFetchRequest:request error:nil];
    [self.switchArray addObjectsFromArray:switchArray];
    [self.aTableView reloadData];
}

- (void)configRoomImage
{
    SwitchEntity *theSwitch = self.switchArray[0];
    self.thumbnailImageView.image = [UIImage imageWithData:theSwitch.roomImageData];
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
    
#if TARGET_IPHONE_SIMULATOR
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
#else
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
#endif
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.thumbnailImageView.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 传给下一级、下下一级添加switch的roomImageData数据
    self.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
    
    // 图片数据写进core data
    for (SwitchEntity *theSwitch in self.switchArray) {
        theSwitch.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
    }
    [APP_DELEGATE saveContext];
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
        
        SwitchEntity *theSwitch = self.switchArray[i];
        
        GridView *gridView = [GridView getNibInstance];
        gridView.delegate = self;
        gridView.switchEntity = theSwitch;
        gridView.frame = CGRectMake(X, Y, kGridWidth, kGridHeight);
        gridView.tag = kGridViewTag + i;
        gridView.stateLabel.text = theSwitch.name;
        gridView.thumbnailImageView.image = [UIImage imageNamed:theSwitch.imageName];
        
        if (i == self.switchArray.count - 1) { // 添加设备 格子
            gridView.tag = kGridOfAddDeviceTag;
        } else {
            
        }
        
        [cell.contentView addSubview:gridView];
    }
    
    
    return cell;
}

#pragma mark - GridViewDelegate
- (void)gridViewAddSwitch:(GridView *)gridView
{
    // "添加设备"，委托到 RoomController 完成
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomFirstLevelControllerAddSwitch:)]) {
        NSParameterAssert(self.roomImageData != 0);
        [self.delegate roomFirstLevelControllerAddSwitch:self];
    }
}

- (void)gridViewLongPress:(GridView *)gridView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomFirstLevelControllerLongPress:)]) {
        [self.delegate roomFirstLevelControllerLongPress:self];
    }
}

@end

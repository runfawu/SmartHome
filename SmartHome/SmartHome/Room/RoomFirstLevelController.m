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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDevicesRegisterFromDataBase) name:ADDLIGHTSUCCESSNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDevicesRegisterFromDataBase) name:ADDSOCKETSUCCESSNOTIFICATION object:nil];
    
    [self setup];
    [self addTapToImageView];
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    self.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
//    NSParameterAssert(self.roomImageData.length != 0);
//}

#pragma mark - Private methods
- (void)setup
{
    self.roomID = 100; // TODO: 记得修改roomID
    //self.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
    self.aTableView.backgroundColor = [UIColor purpleColor];
    self.switchArray = [NSMutableArray array];
    
    //[self fetchDataFromCoreData];
    //[self configRoomImage];
    
    [self getDevicesRegisterFromDataBase];
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

#warning 房间开关数据存储换成了FMDatabase我就不知道如何判断是电灯还是插座了，增删改查都不大会用，而且拍照的那张图也得相应做本地持久保存。
#warning 现在只是根据你从FMDatabase里查出来的deviceArray做了界面展示，数据改变(如点击界面格子，会有开、关状态改变，得改变Model层里的数据)这些关联fmdatabase的得你自己解决了（本来我用coredata是把这些MVC都关联起来了的，你只需要给我个roomID就可以了）。

//获取DevicesRegister表里房间等于客厅的所有设备
-(void)getDevicesRegisterFromDataBase{
    DeviceDB *db=[DeviceDB sharedInstance];
    NSMutableArray *registerDeviceArray=[db getDevicesWithRoomName:@"客厅"];
    //registerDeviceArray 里面都是Devices对象
    NSLog(@"registerDevice :%@ count =%d",registerDeviceArray,[registerDeviceArray count]);
    
    // 根据FMDatabase取出来的数据展现UI
    [self.switchArray removeAllObjects];
    for (int i = 0; i < registerDeviceArray.count; i ++) {
        Devices *device = registerDeviceArray[i];
        NSLog(@"device.deviceName = %@, roomName = %@, roomID = %d, deviceID = %d, socketID = %d, lightID = %d, state = %d", device.deviceName, device.roomName, device.roomId, device.devicesId, device.socketId, device.lightId, device.state);
        SwitchObject *object = [[SwitchObject alloc] init];
        object.switchName = device.deviceName;
        object.switchFlag = device.state;
        object.switchImageName = @"switch_off";
        [self.switchArray addObject:object];
    }
    
    [self addTheAddSwitch];
    [self.aTableView reloadData];
}

// 添加在最后的 “添加设备” 格子
- (void)addTheAddSwitch
{
    SwitchObject *object = [[SwitchObject alloc] init];
    object.switchName = @"添加设备";
    object.switchFlag = NO;
    object.switchImageName = @"main_add";
    [self.switchArray addObject:object];
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
    
//    // 传给下一级、下下一级添加switch的roomImageData数据
//    self.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
//    
//    // 图片数据写进core data
//    for (SwitchEntity *theSwitch in self.switchArray) {
//        theSwitch.roomImageData = UIImagePNGRepresentation(self.thumbnailImageView.image);
//    }
//    [APP_DELEGATE saveContext];
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
        
        //SwitchEntity *theSwitch = self.switchArray[i];
        SwitchObject *object = self.switchArray[i];
        
        GridView *gridView = [GridView getNibInstance];
        gridView.delegate = self;
        //gridView.switchEntity = theSwitch;
        gridView.frame = CGRectMake(X, Y, kGridWidth, kGridHeight);
        gridView.tag = kGridViewTag + i;
        gridView.stateLabel.text = object.switchName;
        gridView.thumbnailImageView.image = [UIImage imageNamed:object.switchImageName];
        
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
        //NSParameterAssert(self.roomImageData != 0);
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

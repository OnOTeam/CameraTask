//
//  CTPhotoTableViewController.m
//  CameraTask
//
//  Created by Vencoo on 14-8-5.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "CTPhotoTableViewController.h"

#import "CTItemModel.h"

@interface CTPhotoTableViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_dataList;
    
}
@end

@implementation CTPhotoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photo";
    
    _dataList = [[NSMutableArray alloc] init];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:addButton]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)addAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"退出" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)takePhotoAction
{
    //创建图片选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //指定源类型前，检查图片源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //指定源的类型
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
        picker.allowsEditing = YES;
        
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        picker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)selectPhotoAction
{
    //创建图片选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //指定源类型前，检查图片源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        //指定源的类型
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        picker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相册不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma  mark UIImagePickerControllerDelegate

//用户点击图像选取器中的“cancel”按钮时被调用，这说明用户想要中止选取图像的操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//用户点击选取器中的“choose”按钮时被调用，告知委托对象，选取操作已经完成，同时将返回选取图片的实例
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //保存图片
    CTItemModel *model = [[CTItemModel alloc] init];
    
    // 计算实际数据
    model.name = @"Name";
    model.size = 1.0;
    model.date = [NSDate date];
    model.type = 2;
    
    [_dataList addObject:model];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://录制
            [self takePhotoAction];
            break;
            
        case 1://选取
            [self selectPhotoAction];
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    CTItemModel *model = [_dataList objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"icon_photo.png"];
    
    cell.textLabel.text = model.name;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"创建时间:%@,大小:%.3fM",@"2014-8-1",1.0];
    
    return cell;
}

@end

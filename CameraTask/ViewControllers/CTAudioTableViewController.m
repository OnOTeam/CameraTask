//
//  CTAudioTableViewController.m
//  CameraTask
//
//  Created by Vencoo on 14-8-5.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "CTAudioTableViewController.h"

#import "CTItemModel.h"

@interface CTAudioTableViewController ()<UIActionSheetDelegate>
{
    NSMutableArray *_dataList;
    
}
@end

@implementation CTAudioTableViewController

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
    
    self.title = @"Audio";
    
    _dataList = [[NSMutableArray alloc] init];

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:addButton]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents"]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *tempArray = [manager contentsOfDirectoryAtPath:fileDir error:nil];
    
    [_dataList removeAllObjects];
    for (NSString *name in tempArray) {
        CTItemModel *model = [[CTItemModel alloc] init];
        model.name = name;
        [_dataList addObject:model];
        
        NSString *filePath = [fileDir stringByAppendingPathComponent:name];
        
        if([manager fileExistsAtPath:filePath isDirectory:NO]){
            
            NSDictionary * attributes = [manager attributesOfItemAtPath:filePath error:nil];
        
            // 计算大小
            NSNumber *theFileSize = [attributes objectForKey:NSFileSize];
            model.size = [theFileSize intValue] / 1000.0;
            
            // 创建时间
            model.date = [attributes objectForKey:NSFileCreationDate];
        }

    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)addAction:(id)sender
{
    [self audioRecordAction];
}

- (void)audioRecordAction
{
    [self performSegueWithIdentifier:@"CTSAnyToRecordAudio" sender:self];
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
    
    cell.imageView.image = [UIImage imageNamed:@"icon_audio.png"];
    
    cell.textLabel.text = model.name;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时间:%@,大小:%.3fK",[formatter stringFromDate:model.date] ,model.size];
    
    return cell;
}

@end

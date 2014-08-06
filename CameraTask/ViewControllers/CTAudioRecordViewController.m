//
//  CTAudioRecordViewController.m
//  CameraTask
//
//  Created by Vencoo on 14-8-6.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "CTAudioRecordViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface CTAudioRecordViewController ()<UITextFieldDelegate,AVAudioRecorderDelegate>
{
    
    __weak IBOutlet UITextField *_nameTextField;
    
    __weak IBOutlet UILabel *_timeLabel;
    
    __weak IBOutlet UIButton *startButton;
    
    NSInteger _status; // 1:start 2:Pause
    
    //Variable setup for access in the class
    NSURL *recordedTmpFile;
    AVAudioRecorder *recorder;
    
}
@end

@implementation CTAudioRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *error;
    //Instanciate an instance of the AVAudioSession object.
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    //Setup the audioSession for playback and record.
    //We could just use record and then switch it to playback leter, but
    //since we are going to do both lets set it up once.
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    //Activate the session
    [audioSession setActive:YES error: &error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)startAction:(id)sender
{
    
    if (_status != 1) {
        _status = 1;
        [startButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        
        // 设置样式
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
        // 格式
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        // 采样频率
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        // 音量
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        
        // 路径
        recordedTmpFile = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
        NSLog(@"Using File called: %@",recordedTmpFile);
        
        NSError *error;
        //Setup the recorder to use this file and record to it.
        recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];

        
        [recorder setDelegate:self];
        
        [recorder prepareToRecord];
        
        [recorder record];
        
        
    }else {
        _status = 2;
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        
        NSLog(@"Using File called: %@",recordedTmpFile);
        //Stop the recorder.
        [recorder stop];
    }
    
}

- (IBAction)finishAction:(id)sender
{
    if (_status == 1) {
        [recorder stop];
        _status = 0;
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    NSError *error;
    //The play button was pressed...
    //Setup the AVAudioPlayer to play the file that we just recorded.
    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
    NSLog(@"Using File called: %@",recordedTmpFile);
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    avPlayer.volume = 2;
    [avPlayer prepareToPlay];
    [avPlayer play];
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

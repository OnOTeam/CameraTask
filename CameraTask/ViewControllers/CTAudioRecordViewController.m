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
    
    NSTimer *_timer;
    
    NSDate *_startDate;
    
    NSDate *_endDate;
    
    AVAudioPlayer   *_player;
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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.01
                                              target:self
                                            selector:@selector(timeAction:)
                                            userInfo:nil
                                             repeats:YES];
    _timer = timer;
    
    if (_status != 1) {
        
        _startDate = [NSDate date];
        
        _status = 1;
        [startButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        // 设置样式
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
        // 格式
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        // 采样频率
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        // 音量
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        
        // 路径
        recordedTmpFile = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%.0f.%@", [_startDate timeIntervalSince1970] * 1000.0, @"caf"]]];
        NSLog(@"Using File called: %@",recordedTmpFile);
        
        _nameTextField.text = [NSString stringWithFormat: @"%.0f.%@", [_startDate timeIntervalSince1970] * 1000.0, @"caf"];
        
        NSError *error;
        //Setup the recorder to use this file and record to it.
        recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];

        [recorder setDelegate:self];
        
        [recorder prepareToRecord];
        
        [recorder record];
        
        
    }else {
        //Stop the recorder.
        [recorder stop];
        [_timer invalidate];
        
        _status = 2;
        _endDate = [NSDate date];
        
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        
        NSLog(@"save File called: %@",recordedTmpFile);
        
        
    }
    
}

- (IBAction)finishAction:(id)sender
{
    if (_status == 1) {
        [recorder stop];
        
        [_timer invalidate];
        
        _status = 0;
        _endDate = [NSDate date];
        
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    NSError *error;
    //The play button was pressed...
    //Setup the AVAudioPlayer to play the file that we just recorded.
    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
    NSLog(@"Play File called: %@",recordedTmpFile);
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    avPlayer.volume = 2;
    [avPlayer prepareToPlay];
    [avPlayer play];
    _player = avPlayer;
    
}

- (void)timeAction:(id)sender
{
    NSTimeInterval offTime;
    
    if (_status == 1) {
        offTime = -[_startDate timeIntervalSinceNow];
    }else {
        offTime = -[_startDate timeIntervalSinceDate:_endDate];
    }
    
    int totle = offTime * 100;
    
    int mSecond = totle % 100;
    
    int second = (totle / 100) % 60;
    
    int minite = totle / 6000;
    
    _timeLabel.text = [NSString stringWithFormat:@"%d:%2d:%2d",minite,second,mSecond];
    
    //NSLog(@"%f",offTime);
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

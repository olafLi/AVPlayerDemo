//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by TengFeiLi on 2017/3/1.
//  Copyright © 2017年 Dearcc. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic) UISlider * progressSlider;
@property (nonatomic) AVPlayer * player;
@property (nonatomic,assign) CGFloat sumPlayOperation;
@property (nonatomic) AVPlayerLayer * layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString * playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    NSURL * url  = [NSURL URLWithString:playString];
    AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    self.layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    self.layer.videoGravity = AVLayerVideoGravityResizeAspect;

    [self.view.layer addSublayer:self.layer];

    self.player.volume = 1.0f;

    self.progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(50, 350, [UIScreen mainScreen].bounds.size.width - 100, 30)];
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.progressSlider];

    UIButton * startButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 400, 100, 40)];

    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    startButton.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    [self.view addSubview:startButton];

    UIButton * stopButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 400, 100, 40)];
    [stopButton setTitle:@"暂停" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    stopButton.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    [self.view addSubview:stopButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willOritate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];


    UIButton * newButton  = [[UIButton alloc]initWithFrame:CGRectMake(50, 500, 100, 100)];
    newButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:newButton];
    [newButton addTarget:self action:@selector(newPage) forControlEvents:UIControlEventTouchUpInside];
}
-(void)newPage{
    AVPlayerViewController * viewController = [[AVPlayerViewController alloc]init];
    viewController.player = self.player;

    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willOritate:(NSNotification *)notification{
    UIInterfaceOrientation sataus = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(sataus)){
        self.layer.frame = self.view.frame;
    }else{
        self.layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    }
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate{
    return true;
}

-(void)start:(UIButton *) startButton{
    [self.player play];
}

-(void)pause:(UIButton *)stopButton{
    [self.player pause];
}

-(void)changeProgress:(UISlider *) slider {
    self.sumPlayOperation = self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
    [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value * self.sumPlayOperation, self.player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
        if(!finished){
            [self.player play];
        }
    }];
}
@end

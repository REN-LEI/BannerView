//
//  ViewController.m
//  YDBannerView
//
//  Created by renlei on 16/8/17.
//  Copyright © 2016年 renlei. All rights reserved.
//

#import "ViewController.h"
#import "YDBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YDBannerView *bannerView = [[YDBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 250)];
    [self.view addSubview:bannerView];
    bannerView.autoScrollTimeInterval = 3;
    [bannerView setSelectItemAtIndex:^(NSInteger index) {
        NSLog(@"==%@",@(index));
    }];
    NSArray <NSString *>*array = @[@"http://pic32.nipic.com/20130829/2668693_163231948000_2.jpg",
                                   @"http://pic43.nipic.com/20140704/11284670_150403334001_2.jpg",
                                   @"http://img1.kwcdn.kuwo.cn/star/KuwoPhotoArt/0/0/1392798858238_0.jpg",
                                   @"http://img2.3lian.com/2014/f6/75/d/9.jpg"];
    bannerView.imageUrls = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

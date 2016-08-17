//
//  YDBannerView.h
//  YDBannerView
//
//  Created by renlei on 16/8/17.
//  Copyright © 2016年 renlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YDBannerSelectItemAtIndex)(NSInteger index);

@interface YDBannerView : UIView

@property (nonatomic, strong) NSArray <NSString *>*imageUrls;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, copy) YDBannerSelectItemAtIndex selectItemAtIndex;

- (void)suspendTimer;

- (void)resumeTimer;

@end

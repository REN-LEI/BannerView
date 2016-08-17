//
//  YDBannerCell.m
//  YDBannerView
//
//  Created by renlei on 16/8/17.
//  Copyright © 2016年 renlei. All rights reserved.
//

#import "YDBannerCell.h"
#import "UIImageView+WebCache.h"

@interface YDBannerCell ()

@property (nonatomic, strong) UIImageView *bannerImageView;

@end

@implementation YDBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bannerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bannerImageView];
    }
    return self;
}

- (void)rl_setImageUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    
    if (!placeholderImage) {
        [_bannerImageView setShowActivityIndicatorView:YES];
        [_bannerImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    if ([urlString hasPrefix:@"http"]) {
        [_bannerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image && cacheType == SDImageCacheTypeNone)  {
                CAAnimation *animation = nil;
                if (placeholderImage) {
                    CATransition *transition = [CATransition animation];
                    animation = transition;
                } else {
                    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    basicAnimation.fromValue = [NSNumber numberWithFloat:.0];
                    basicAnimation.toValue = [NSNumber numberWithFloat:1];
                    animation = basicAnimation;
                }
                animation.duration = 0.5;
                [_bannerImageView.layer addAnimation:animation forKey:nil];
            } else if (error) {
                NSLog(@"下载失败");
            }
        }];
    } else if (urlString.length != 0) {
        _bannerImageView.image = [UIImage imageWithContentsOfFile:urlString];
    } else {
        _bannerImageView.image = placeholderImage;
    }
}

@end

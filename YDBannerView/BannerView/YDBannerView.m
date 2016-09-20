//
//  YDBannerView.m
//  YDBannerView
//
//  Created by renlei on 16/8/17.
//  Copyright © 2016年 renlei. All rights reserved.
//

#import "YDBannerView.h"
#import "YDBannerCell.h"

@interface YDBannerView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YDBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpBannerView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpBannerView];
}

- (void)setUpBannerView {
    
    _totalNumber = 0;
    _currentPage = 0;
    _autoScrollTimeInterval = 0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.frame.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _mCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _mCollectionView.pagingEnabled = YES;
    _mCollectionView.showsHorizontalScrollIndicator = NO;
    _mCollectionView.delegate = self;
    _mCollectionView.dataSource = self;
    [_mCollectionView registerClass:YDBannerCell.class forCellWithReuseIdentifier:@"YDBanner"];
    _mCollectionView.backgroundColor = self.backgroundColor;
    [self addSubview:_mCollectionView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.center = CGPointMake(self.center.x, CGRectGetHeight(self.frame)-15);
    _pageControl.numberOfPages = self.imageUrls.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _mCollectionView.backgroundColor = self.backgroundColor;
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setUpTimer];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setUpTimer {
    [self invalidateTimer];
    if (_autoScrollTimeInterval > 0 && _imageUrls.count > 0) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
}

- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)automaticScroll:(NSTimer *)timer {
    
    NSArray <NSIndexPath *>*indexPathsForVisibleItems = [self.mCollectionView indexPathsForVisibleItems];
    
    if (indexPathsForVisibleItems.count) {
        NSIndexPath *indexPath = indexPathsForVisibleItems.lastObject;
        self.currentPage = indexPath.item;
    }
    if (timer) {
        self.currentPage++;
        [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }

    self.pageControl.currentPage = self.currentPage % _imageUrls.count;
}

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls {
    if (imageUrls.count == 0) {
        return;
    }
    _imageUrls = imageUrls;
    if (imageUrls.count == 1) {
        _totalNumber = imageUrls.count;
    }
    else {
        _totalNumber = imageUrls.count *100;
        [self setUpTimer];
        _pageControl.numberOfPages = self.imageUrls.count;
    }
    [self.mCollectionView reloadData];
    [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalNumber*0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YDBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDBanner" forIndexPath:indexPath];
    NSString *imageUrlString = _imageUrls[indexPath.item % _imageUrls.count];
    [cell rl_setImageUrlString:imageUrlString placeholderImage:self.placeholderImage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectItemAtIndex) self.selectItemAtIndex(indexPath.row % _imageUrls.count);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat w = CGRectGetWidth(self.mCollectionView.frame);
    
    if (scrollView.contentOffset.x >= w *_totalNumber - (_imageUrls.count *w) ||
        scrollView.contentOffset.x <= _imageUrls.count *w)
    {
        [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalNumber*0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self automaticScroll:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self suspendTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resumeTimer];
}

- (void)suspendTimer {
    if (self.timer) self.timer.fireDate = [NSDate distantFuture];
}

- (void)resumeTimer {
    if (self.timer)
        self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:_autoScrollTimeInterval];
}

@end

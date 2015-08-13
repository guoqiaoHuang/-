//
//  Photo.m
//  微博
//
//  Created by sky on 14-10-11.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "Photo.h"
#import "UIImageView+WebCache.h"

@implementation Photo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        scrollView.delegate = self;
        scrollView.minimumZoomScale = .5;
        scrollView.maximumZoomScale = 2;
        _scrollView  = scrollView;
        // Initialization code
        _imageView = [[UIImageView alloc] init];
        //显示照片一共几张,现在处在第几张(2/6形式)
        _label = [[UILabel alloc] init];
        //文字居中
        _label.textAlignment = NSTextAlignmentCenter;
        //设置label的frame
        _label.frame = CGRectMake(0, 0, 320, 30);
        _label.textColor = [UIColor whiteColor];
        //设置图片的填充模式
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        //双击缩放手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageScale:)];
        doubleTap.numberOfTapsRequired = 2;
        
        //单击返回手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        tap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:tap];
        [_imageView addGestureRecognizer:doubleTap];
        [tap requireGestureRecognizerToFail:doubleTap];
        
        [scrollView addSubview:_label];
        [scrollView addSubview:_imageView];

        [self addSubview:scrollView];

    }
    return self;
}

#pragma mark   点击返回
- (void)back:(UITapGestureRecognizer *)tap
{
    [self.delegate PhotoTap:self];
}

#pragma mark 缩放图片
- (void)imageScale:(UITapGestureRecognizer *)tap
{
    
    if (_scrollView.zoomScale == _scrollView.maximumZoomScale) {
        [_scrollView setZoomScale:1];
    } else {
       CGPoint location = [tap locationInView:self];
        [_scrollView zoomToRect:CGRectMake(location.x, location.y, 1, 1) animated:YES];
    }
}
- (void)setUrl:(NSString *)url
{
    //下载进度
    _hud.hidden = YES;
    _hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(200, 300, 60, 60)];
    [self addSubview:_hud];
    // Set determinate mode
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.delegate = self;
    _hud.labelText = @"Loading";
    [_hud performSelector:@selector(show:) withObject:@YES afterDelay:0.5];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            _hud.progress = (float)receivedSize / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _hud.hidden = YES;
        _imageView.bounds = _srcFrame;
        _imageView.center = [[UIApplication sharedApplication] keyWindow].center;
        [UIView animateWithDuration:.3 animations:^{

            _imageView.frame = CGRectMake(20, 30, 280, 380);

        }];
    }];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hud removeFromSuperview];
    _hud = nil;
}
@end

//
//  PicList.m
//  微博
//
//  Created by sky on 14-10-5.
//  Copyright (c) 2014年 sky. All rights reserved.
//子类化相册视图

#import "PicList.h"
//#import "UIView+NextResponder.h"
#import <UIImageView+WebCache.h>
#import "PhotoAlbum.h"

@implementation PicList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        [self _initViews];
    }
    return self;
}
/**
 *  初始化视图
 */
- (void)_initViews
{

    for (int i =0; i < 9; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i + 101;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
}
+ (CGSize)getPicListSize:(NSInteger) count{
    float rowCount;
    if (count == 1) {
        return CGSizeMake(KPICONEW, KPICONEW);
    } else {
        rowCount = (count == 2 || count == 4)?2.0:3.0;
    }
    //计算配图的整体高度
    NSInteger picHeight = (KPICH + KBaseSpace) * ceilf(count/rowCount);
    NSInteger picWidth = (KPICW + KBaseSpace) * rowCount;
    return  CGSizeMake(picWidth,picHeight);
}

- (void)setPicUrls:(NSArray *)picUrls
{
    _picUrls = picUrls;
    NSInteger count= [_picUrls count];
    int rowCount;
    if (count == 1) {
        rowCount = 1;
    } else {
        rowCount = (count == 2 || count == 4)?2:3;
    }
    for (int i= 0; i < 9; ++i) {

        UIImageView *imageView = (UIImageView *)[self viewWithTag:i + 101];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlbum:)];
        
        // 添加手势
        [imageView addGestureRecognizer:tap];
        if (i < count) {
            imageView.hidden = NO;
            imageView.userInteractionEnabled = YES;
            NSString * url = picUrls[i][@"thumbnail_pic"];
            UIImage *placeholder = [UIImage imageNamed:@"Icon.png"];

            if (count == 1) {
                //只有一张图片时
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    CGFloat w = image.size.width;
                    CGFloat h = image.size.height;
                    w = w / (h/KPICONEH);
                    w = MIN(w, KPICONEW);
                    [imageView setFrame:CGRectMake(0, 0, w, KPICONEH)];
                    
                }];
                imageView.frame = CGRectMake(0, 0, KPICONEW, KPICONEH);
                continue;
                
            }
            int x = (KBaseSpace + KPICW) * (i%rowCount);
            int y = (KBaseSpace + KPICH) * (i/rowCount);
            
            imageView.frame = CGRectMake(x, y, KPICW, KPICH);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            //下载图片
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageContinueInBackground];
        } else {
            imageView.hidden = YES;
        }
        
    }
}
- (void)showAlbum:(UITapGestureRecognizer *)tap
{
    PhotoAlbum *album = [[PhotoAlbum alloc] init];
    //得到中等图片的url
    album.photosUrl = [self getMiddleUrl:_picUrls];
    album.srcFrames = [NSMutableArray array];
    NSArray *frame = [self getAllPicFrameWithTag:tap.view.tag withFrame:tap.view.frame];
    //取得piclist中的图片相对于屏幕的位置(显示在album中的位置)
    for (NSValue *val in frame) {
        
        CGRect rect = [self convertRect:[val CGRectValue] toView:self.window];
        [album.srcFrames addObject:[NSValue valueWithCGRect:rect]];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //把album添加到最上面(直接加在window上)
    [window addSubview:album];
    [album setContentOffset:CGPointMake(Main_Screen_Width * (tap.view.tag - 101), 0)];
}

//通过缩略图的地址得到中等图片的地址
- (NSArray *)getMiddleUrl:(NSArray *)picUrl
{
    NSMutableArray *bMiddleUrl = [NSMutableArray array];
    for (NSDictionary *pic in picUrl) {
        NSArray *arr = [pic[@"thumbnail_pic"] componentsSeparatedByString:@"/"];
        NSMutableArray *arr2 = [NSMutableArray arrayWithArray:arr];
        arr2[arr.count - 2] = @"bmiddle";
        NSString *str = [arr2 componentsJoinedByString:@"/"];
        [bMiddleUrl addObject:str];
    }
    return bMiddleUrl;
}

- (NSArray *)getAllPicFrameWithTag:(NSInteger)tag withFrame:(CGRect)frame
{
    NSInteger count = _picUrls.count;
    NSInteger rowCount;

    if (count == 1) {
        return @[[NSValue valueWithCGRect:frame]];
    }
    NSMutableArray *frames = [NSMutableArray array];
  
    rowCount = (count == 2 || count == 4)?2:3;
    
    for (int i= 0; i < count; ++i) {
        
            NSInteger x =frame.origin.x + (KBaseSpace + KPICW) * ((i + 101 -tag)%rowCount);
            NSInteger y =frame.origin.y + (KBaseSpace + KPICH) * ((i + 101 -tag)/rowCount);
        
        [frames addObject:[NSValue valueWithCGRect:CGRectMake(x, y, KPICW, KPICH)]];
     }
    return frames;
}

@end

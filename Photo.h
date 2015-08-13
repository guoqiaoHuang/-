//
//  Photo.h
//  微博
//
//  Created by sky on 14-10-11.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

//基本间距
#define KBaseSpace      10

//配图的大小
#define KPICW              80
#define KPICH              80

//只有一张配图时配图的大小
#define KPICONEW           120
#define KPICONEH           120

@class Photo;
@protocol  PhotoTap <NSObject>

- (void)PhotoTap:(Photo *)photo;
@end

@interface Photo : UICollectionViewCell<UIScrollViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGRect srcFrame;                  //照片在照片查看器中的位置

@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, assign) id<PhotoTap> delegate;
@property (nonatomic, weak) UIScrollView * scrollView;

@end

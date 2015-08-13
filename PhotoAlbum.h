//
//  PhotoAlbum.h
//  微博
//
//  Created by sky on 14-10-11.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@class LoadProgress;

@interface PhotoAlbum : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoTap>

@property (nonatomic, retain) LoadProgress *loadProgress;       //加载进度条
@property (nonatomic, copy) NSArray *photosUrl;               //图片url数组
@property (nonatomic, retain) NSMutableArray *srcFrames;         //图片
@end

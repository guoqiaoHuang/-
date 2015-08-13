//
//  PicList.h
//  微博
//
//  Created by sky on 14-10-5.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicList : UIView

@property (nonatomic, copy) NSArray *picUrls;           //图片的url数组


//给出配图的个数计算配图的宽和高
+ (CGSize)getPicListSize:(NSInteger) count;
- (NSArray *)getAllPicFrameWithTag:(NSInteger)tag withFrame:(CGRect)frame;
@end

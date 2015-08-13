//
//  PhotoAlbum.m
//  微博
//
//  Created by sky on 14-10-11.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "PhotoAlbum.h"

@interface PhotoAlbum (){

    NSString *_identity;
    NSString *_identityHeader;
}
@end

@implementation PhotoAlbum

- (id)initWithFrame:(CGRect)frame
{
    
    _identity = @"CollectionViewCell";
    _identityHeader = @"CollectionViewHeader";
    //初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(Main_Screen_Width, Main_Screen_Height);
    layout.minimumLineSpacing = 0;
    self.backgroundColor = RGB(80, 80, 80, 1);
    self = [super initWithFrame:frame  collectionViewLayout:layout];
    if (self) {
        [self registerClass:[Photo class] forCellWithReuseIdentifier:_identity];
       // [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:_identityHeader];
        self.delegate = self;
        self.dataSource = self;
        //隐藏水平滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.frame = [[UIApplication sharedApplication] keyWindow].bounds;
        self.pagingEnabled = YES;
    }
    return self;
}
#pragma  mark    collection的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosUrl.count;
}
#pragma mark     每个collectionview的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *cell = [self dequeueReusableCellWithReuseIdentifier:_identity forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%d/%d",(int)indexPath.row + 1,(int)_photosUrl.count];
    cell.srcFrame = [_srcFrames[indexPath.row] CGRectValue];
    
    cell.delegate = self;
    //设置图片的url
    cell.url = _photosUrl[indexPath.row];
    return cell;
}
#pragma mark  collectionviewcell结束显示
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *pcell = (Photo *)cell;
    //还原放大后的图片
    [pcell.scrollView setZoomScale:1];
    
}
- (void)PhotoTap:(Photo *)photo
{
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:.3 animations:^{
        photo.imageView.contentMode = UIViewContentModeScaleAspectFill;
        photo.imageView.frame = photo.srcFrame;
        
    } completion:^(BOOL finished) {
        //把album从视图中移除
        [self removeFromSuperview];
    }];

}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if (kind == UICollectionElementKindSectionHeader) {
//        UICollectionReusableView * header = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:_identityHeader forIndexPath:indexPath];
//        UILabel *label = [[UILabel alloc] init];
//        label.text = @"第一组";
//        [header addSubview:label];
//        return header;
//    }
//    return nil;
//
//}
@end

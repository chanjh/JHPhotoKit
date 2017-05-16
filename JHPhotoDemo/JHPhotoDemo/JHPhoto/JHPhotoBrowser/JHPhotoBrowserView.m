//
//  JHPhotoBrowserView.m
//  PhotoScroll
//
//  Created by 陈嘉豪 on 2017/5/4.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoBrowserView.h"
#import "JHPHAsset.h"
#import <PhotosUI/PhotosUI.h>
typedef NS_ENUM(NSUInteger, JHPhotoBrowserDire) {
    JHPhotoBrowserDireNone,
    JHPhotoBrowserDireUp,
    JHPhotoBrowserDireDown,
};

@interface JHPhotoBrowserView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
@property (nonatomic, assign) JHPhotoBrowserDire dire;

@end

@implementation JHPhotoBrowserView{
    UIImage *_image;
    JHPHAsset *_asset;
}

- (void)setViewWithAsset:(JHPHAsset *)asset{
    _asset = asset;
    [self.scrollView removeFromSuperview];
    [self setupContentView];
}

- (void)setupContentView{
    __weak typeof(self)weakSelf = self;
    [_asset getOriginImageWithBlock:^(UIImage *image) {
        __weak typeof(weakSelf)strongSelf = weakSelf;
        _image = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf setupImageView];
            if(_asset.assetType == JHPhotoAssetTypePhotoLive){
                [strongSelf setupLivePhotoView];
                [strongSelf setupScrollView];
                [strongSelf.scrollView addSubview:strongSelf.livePhotoView];
            }else{
                [strongSelf setupScrollView];
                [strongSelf.scrollView addSubview:strongSelf.imageView];
            }
        });
    }];
}
- (void)setupLivePhotoView{
    CGFloat imgViewH = _image.size.height/_image.size.width * self.frame.size.width;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, imgViewH);
    self.livePhotoView = [[PHLivePhotoView alloc]initWithFrame:frame];
    self.livePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    if(imgViewH < self.frame.size.height){
        [self.livePhotoView setCenter:CGPointMake(self.frame.size.width/2, self.center.y)];
    }
    JHPHLivePhotoAsset *livePhotoAsset = (JHPHLivePhotoAsset *)_asset;
    [livePhotoAsset getLivePhotoWithBlock:^(PHLivePhoto *livePhoto) {
        self.livePhotoView.livePhoto = livePhoto;
        [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    }];
}
- (void)setupImageView{
    CGFloat imgViewH = _image.size.height/_image.size.width * self.frame.size.width;
    self.imageView = [[UIImageView alloc]init];
    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, imgViewH)];
    if(imgViewH < self.frame.size.height){
        [self.imageView setCenter:CGPointMake(self.frame.size.width/2, self.center.y)];
    }
    [self.imageView setImage:_image];
    self.imageView.userInteractionEnabled = YES;
}

- (void)setupScrollView{
    CGRect frame = self.frame;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, frame.origin.y+64, frame.size.width, frame.size.height)];
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    _scrollView.delegate = self;
    
    CGFloat scrollViewH;
    if(self.imageView.frame.size.height > self.frame.size.height){
        scrollViewH = self.imageView.frame.size.height;
    }else{
        scrollViewH = self.frame.size.height;
    }
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, scrollViewH);
    _scrollView.bounces = YES;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 1.0;
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self addSubview:self.scrollView];
}

# pragma mark - UIScrollViewDelegate
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

@end

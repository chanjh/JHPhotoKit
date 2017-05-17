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
#import "UIImage+animatedGIF.h"

@interface JHPhotoBrowserView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;

@end

@implementation JHPhotoBrowserView{
    UIImage *_image;
    JHPHAsset *_asset;
    CGRect _firstFrame;             // 手势启动时，图层的位置
}

- (void)setViewWithAsset:(JHPHAsset *)asset{
    _asset = asset;
    [self.scrollView removeFromSuperview];
    [self setupContentView];
}

# pragma mark - 设置 UI
- (void)setupContentView{
    __weak typeof(self)weakSelf = self;
    [_asset getOriginImageWithBlock:^(UIImage *image) {
        __weak typeof(weakSelf)strongSelf = weakSelf;
        _image = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf setupImageView];
            if(_asset.assetType == JHPhotoAssetTypePhotoLive)
            {
                [strongSelf setupLivePhotoView];
                [strongSelf setupScrollView];
                [strongSelf.scrollView addSubview:strongSelf.livePhotoView];
            }
            else if (_asset.assetType == JHPhotoAssetTypeGif){
                [strongSelf setupGIFImageView];
                [strongSelf setupScrollView];
                [strongSelf.scrollView addSubview:strongSelf.imageView];
            }
            else
            {
                [strongSelf setupScrollView];
                [strongSelf.scrollView addSubview:strongSelf.imageView];
            }
        });
    }];
}

/**
 *  根据不同的 Asset 类型布局缩略图
 */
- (void)setupLivePhotoView{
    CGFloat imgViewH = _image.size.height/_image.size.width * self.frame.size.width;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, imgViewH);
    self.livePhotoView = [[PHLivePhotoView alloc]initWithFrame:frame];
    self.livePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    if(imgViewH < self.frame.size.height){
        [self.livePhotoView setCenter:CGPointMake(self.frame.size.width/2, self.center.y)];
    }
    __weak typeof(self)weakSelf = self;
    JHPHLivePhotoAsset *livePhotoAsset = (JHPHLivePhotoAsset *)_asset;
    [livePhotoAsset getLivePhotoWithBlock:^(PHLivePhoto *livePhoto) {
        __weak typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.livePhotoView.livePhoto = livePhoto;
        [strongSelf.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    }];
}

- (void)setupGIFImageView{
    CGFloat imgViewH = _image.size.height/_image.size.width * self.frame.size.width;
    self.imageView = [[UIImageView alloc]init];
    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, imgViewH)];
    if(imgViewH < self.frame.size.height){
        [self.imageView setCenter:CGPointMake(self.frame.size.width/2, self.center.y)];
    }
    __weak typeof(self)weakSelf = self;
    JHPHGifAsset *gifAsset = (JHPHGifAsset *)_asset;
    [gifAsset getGIFDataWithBlock:^(NSData *gifData) {
        __weak typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.imageView setImage:[UIImage animatedImageWithAnimatedGIFData:gifData]];
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
/**
 * 设置 scrollView
 */
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

# pragma mark - Gesture Handler
- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        // 手势一开始移动时，图层的位置
        _firstFrame = recognizer.view.frame;
    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        // 图片跟着手势移动
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
        [recognizer.view setFrame:CGRectMake(_firstFrame.origin.x + [panGestureRecognizer translationInView:self].x , _firstFrame.origin.y + [panGestureRecognizer translationInView:self].y, _firstFrame.size.width, _firstFrame.size.height)];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        // 结束手势
        [recognizer.view setFrame:_firstFrame];
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
        [panGestureRecognizer setTranslation:CGPointZero inView:recognizer.view];
        if([self.delegate respondsToSelector:@selector(viewShouldDismiss)]){
            [self.delegate viewShouldDismiss];
        }
        
    }
}

# pragma mark - UIGestur eDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [panGestureRecognizer translationInView:gestureRecognizer.view];
        // 速度
//        NSLog(@"X :%f",[panGestureRecognizer velocityInView:gestureRecognizer.view].x);
//        NSLog(@"Y :%f",[panGestureRecognizer velocityInView:gestureRecognizer.view].y);
        // 位移
//        NSLog(@"X :%f",[panGestureRecognizer translationInView:gestureRecognizer.view].x);
//        NSLog(@"Y :%f",[panGestureRecognizer translationInView:gestureRecognizer.view].y);
        if(fabs(point.y)>= fabs(point.x))
        {
            // 用于移动图片图层
            return YES;
        }
        else
        {
            // 滚动图片背后的 collectionView 图层
            UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
            [panGestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
            return NO;
        }
    }
    return YES;
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

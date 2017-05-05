//
//  JHPhotoBrowserView.m
//  PhotoScroll
//
//  Created by 陈嘉豪 on 2017/5/4.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoBrowserView.h"

@interface JHPhotoBrowserView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JHPhotoBrowserView

- (void)setImageWithImage:(UIImage *)image{
    [self.scrollView removeFromSuperview];
    
    CGFloat imgViewH = image.size.height/image.size.width * self.frame.size.width;
    self.imageView = [[UIImageView alloc]init];
    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, imgViewH)];
    
    if(imgViewH < self.frame.size.height){
        [self.imageView setCenter:CGPointMake(self.frame.size.width/2, self.center.y)];
    }
    [self.imageView setImage:image];
    [self setupScrollView];
}
- (void)setupScrollView{
    CGRect frame = self.frame;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height)];
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
    [_scrollView addSubview:_imageView];
    [self addSubview:self.scrollView];
}


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
    NSLog(@"%f",scrollView.contentOffset.x);
    NSLog(@"%f",scrollView.contentOffset.y);
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

@end

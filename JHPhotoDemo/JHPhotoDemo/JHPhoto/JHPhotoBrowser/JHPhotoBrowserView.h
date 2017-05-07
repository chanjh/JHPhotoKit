//
//  JHPhotoBrowserView.h
//  PhotoScroll
//
//  Created by 陈嘉豪 on 2017/5/4.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHPHAsset;
/**
 * 图片浏览器中的 cell
 */
@interface JHPhotoBrowserView : UICollectionViewCell
- (void)setViewWithAsset:(JHPHAsset *)asset;
@end

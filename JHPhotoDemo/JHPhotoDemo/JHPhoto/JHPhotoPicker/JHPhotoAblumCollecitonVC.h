//
//  JHPhotoAblumCollecitonVC.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/7.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPhotoHeader.h"

/**
 * 选取相册
 */
@interface JHPhotoAblumCollecitonVC : UIViewController

- (instancetype)initWithFrame:(CGRect)frame andPhotoCollection:(NSArray <JHPhotoCollection *> *)collectionList;

@end


/*
 * JHPhotoAblumCollecitonView
 */
@interface JHPhotoAblumCollecitonView : UIView

- (instancetype)initWithFrame:(CGRect)frame andPhotoCollection:(NSArray <JHPhotoCollection *> *)collectionList;

@property (nonatomic, strong, readonly) NSArray <JHPhotoCollection *> *photoCollectionList;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

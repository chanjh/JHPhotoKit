//
//  JHPhotoAblumCollecitonView.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/1.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPhotoHeader.h"

@interface JHPhotoAblumCollecitonView : UIView

- (instancetype)initWithFrame:(CGRect)frame andPhotoCollection:(NSArray <JHPhotoCollection *> *)collectionList;

@property (nonatomic, strong, readonly) NSArray <JHPhotoCollection *> *photoCollectionList;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

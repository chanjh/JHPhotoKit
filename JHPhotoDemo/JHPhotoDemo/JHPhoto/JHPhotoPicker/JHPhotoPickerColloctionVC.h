//
//  JHPhotoPickerColloctionVC.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/7.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPHAsset.h"

/**
 * 选取图片
 */
@interface JHPhotoPickerColloctionVC : UIViewController
- (instancetype)initWithFrame:(CGRect)frame andPhotoAssets:(NSArray<JHPHAsset *> *)assetList;
@end




/**
 * JHPhotoPickerColloctionView
 */
@protocol JHPhotoPickerDelegate <NSObject>

@optional
-(void)didSelectAtIndex:(NSInteger)index;

@end
@interface JHPhotoPickerColloctionView : UIView

- (instancetype)initWithFrame:(CGRect)frame andPhotoAssets:(NSArray <JHPHAsset *> *)assetList;

@property (nonatomic, strong, readonly) NSArray <JHPHAsset *> *assetList;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<JHPhotoPickerDelegate> delegate;

@end

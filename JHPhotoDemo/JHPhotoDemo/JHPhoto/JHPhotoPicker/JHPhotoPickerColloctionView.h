//
//  JHPhotoPickerColloctionView.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/2.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPHAsset.h"

@interface JHPhotoPickerColloctionView : UIView

- (instancetype)initWithFrame:(CGRect)frame andPhotoAssets:(NSArray <JHPHAsset *> *)assetList;

@property (nonatomic, strong, readonly) NSArray <JHPHAsset *> *assetList;

@end

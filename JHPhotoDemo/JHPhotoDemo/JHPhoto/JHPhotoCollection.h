//
//  JHPhotoCollection.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoHeader.h"

@interface JHPhotoCollection : NSObject

/**
 * PHCollection 有两个子类
 * PHAssetCollction:相册
 * PHCollectionList:文件夹
 */

- (instancetype)initWithPHCollection:(PHAssetCollection *)collection;
+ (instancetype)collectionWithPHCollection:(PHAssetCollection *)collection;

@property (nonatomic, strong, readonly) NSString *collectionName;
@property (nonatomic, strong, readonly) PHAssetCollection *collection;
@property (nonatomic, strong, readonly) UIImage *thumbImage;
@property (nonatomic, assign, readonly) NSInteger countOfAsset;

@end

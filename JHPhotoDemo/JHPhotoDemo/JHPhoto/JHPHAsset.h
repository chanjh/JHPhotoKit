//
//  JHPHAsset.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoHeader.h"

typedef NS_ENUM(NSUInteger, JHPhotoAssetType) {
    JHPhotoAssetTypePhoto,      // 普通图片
    JHPhotoAssetTypeVideo,      // 视频
    JHPhotoAssetTypeLivePhoto,  // Live Photo
    JHPhotoAssetTypeGif,        // Gif
    JHPhotoAssetTypePanoramic,  // 全景图
};

/**
 * PHAsset 封装后的对象
 * 包括图片、视频等媒体类型
 */
@interface JHPHAsset : NSObject

@property (nonatomic, assign) JHPhotoAssetType assetType;

@end

# pragma mark - 普通图片
@interface JHPhotoAsset : JHPHAsset

@end

# pragma mark - Gif 图
@interface JHPHGifAsset : JHPHAsset

@end

# pragma mark - Live Photo
@interface JHPHLivePhotoAsset : JHPHAsset

@end

# pragma mark - 视频
@interface JHPHVideoAsset : JHPHAsset

@end

# pragma mark - 全景图
@interface JHPHPanoramicAsset : JHPHAsset

@end

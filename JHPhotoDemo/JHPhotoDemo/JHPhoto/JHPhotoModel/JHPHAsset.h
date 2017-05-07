//
//  JHPHAsset.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, JHPhotoAssetType) {
    JHPhotoAssetTypeNone = 0,

    // Photo types
    JHPhotoAssetTypePhotoPanorama      = (1UL << 0),
    JHPhotoAssetTypePhotoHDR           = (1UL << 1),
    JHPhotoAssetTypePhotoScreenshot    = (1UL << 2),
    JHPhotoAssetTypePhotoLive          = (1UL << 3),
    JHPhotoAssetTypePhotoDepthEffect   = (1UL << 4),
    
    // Video types
    JHPhotoAssetTypeVideoStreamed      = (1UL << 16),
    JHPhotoAssetTypeVideoHighFrameRate = (1UL << 17),
    JHPhotoAssetTypeVideoTimelapse     = (1UL << 18),
};

/**
 * PHAsset 封装后的对象
 * 包括图片、视频等媒体类型
 */

// 使用类簇的方法衍生出几个 JHPHAsset 类
@interface JHPHAsset : NSObject

- (instancetype)initWithPHAsset:(PHAsset *)asset;
+ (instancetype)assetWithPHAsset:(PHAsset *)asset;

- (void)getOriginImageWithBlock:(void(^)(UIImage *image))block;
- (void)getThumbImageWithBlock:(void(^)(UIImage *image))block;

@property (nonatomic, strong, readonly) PHAsset *asset;
@property (nonatomic, assign, readonly) JHPhotoAssetType assetType;

@property (nonatomic, weak) UIImage *thumbImage;
@property (nonatomic, weak) NSURL *thumbImageURL;
@property (nonatomic, weak) UIImage *originImage;
@property (nonatomic, weak) NSURL *originImageURL;

// 图片一些常见的属性
// 拍摄地点
// 图片大小
// 光圈、ISO
@property (nonatomic, assign) NSUInteger fileLength;     // 单位：kb

@end

# pragma mark - 普通图片
@interface JHPhotoAsset : JHPHAsset

@end

# pragma mark - Gif 图
@interface JHPHGifAsset : JHPHAsset

@end

# pragma mark - Live Photo
@interface JHPHLivePhotoAsset : JHPHAsset
- (void)getLivePhotoWithBlock:(void(^)(PHLivePhoto *livePhoto))block;
@property (nonatomic, strong, readonly) PHLivePhoto *livePhoto;
@end

# pragma mark - 视频
@interface JHPHVideoAsset : JHPHAsset

@end

# pragma mark - 全景图
@interface JHPHPanoramicAsset : JHPHAsset

@end

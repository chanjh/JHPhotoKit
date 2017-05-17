//
//  JHPHAsset.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPHAsset.h"

@interface JHPHAsset()

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) JHPhotoAssetType assetType;

@end

@implementation JHPHAsset

- (instancetype)initWithPHAsset:(PHAsset *)asset{
    if(self = [super init]){
        self.asset = asset;
        self.assetType = (JHPhotoAssetType)asset.mediaSubtypes;
    }
    return self;
}

+ (instancetype)assetWithPHAsset:(PHAsset *)asset{
    JHPHAsset *jhPHAsset = [[JHPHAsset alloc]initWithPHAsset:asset];
    return jhPHAsset;
}

- (void)getThumbImageWithBlock:(void(^)(UIImage *image))block{
    CGSize targetSize = CGSizeMake(150, 150);
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager]requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if(block){
            block(result);
        }
    }];
}
- (void)getOriginImageWithBlock:(void(^)(UIImage *image))block{
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager]requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if(block){
            block(result);
        }
    }];
}
@end

# pragma mark - Gif 图
@implementation JHPHGifAsset
- (instancetype)initWithPHAsset:(PHAsset *)asset{
    if(self = [super initWithPHAsset:asset]){
        self.assetType = JHPhotoAssetTypeGif;
    }
    return self;
}

+ (instancetype)assetWithPHAsset:(PHAsset *)asset{
    JHPHGifAsset *gifAsset = [[JHPHGifAsset alloc]initWithPHAsset:asset];
    return gifAsset;
}

- (void)getGIFDataWithBlock:(void(^)(NSData *gifData))block{
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:requestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if(block){
            block(imageData);
        }
    }];
}

@end

# pragma mark - Live Photo
@interface JHPHLivePhotoAsset()
@property (nonatomic, strong) PHLivePhoto *livePhoto;
@end

@implementation JHPHLivePhotoAsset
- (instancetype)initWithPHAsset:(PHAsset *)asset{
    if(self = [super initWithPHAsset:asset]){

    }
    return self;
}

+ (instancetype)assetWithPHAsset:(PHAsset *)asset{
    JHPHLivePhotoAsset *lpAsset = [[JHPHLivePhotoAsset alloc]initWithPHAsset:asset];
    return lpAsset;
}
- (void)getLivePhotoWithBlock:(void(^)(PHLivePhoto *livePhoto))block{
    CGSize targetSize = [UIScreen mainScreen].bounds.size;
    PHLivePhotoRequestOptions *requestOptions = [[PHLivePhotoRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestLivePhotoForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        self.livePhoto = livePhoto;
        if(block){
            block(livePhoto);
        }
    }];
}
@end



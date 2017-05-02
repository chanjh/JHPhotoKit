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

- (UIImage *)thumbImage{
    if(!_thumbImage){
        CGSize targetSize = CGSizeMake(10*1.5, 10*1.5);
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;
//        __block UIImage *resultImage;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[PHImageManager defaultManager]requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                resultImage = result;
                dispatch_barrier_async(dispatch_get_main_queue(), ^{
                    _thumbImage = result;
                });
            }];
        });
//        dispatch_barrier_async(dispatch_get_main_queue(), ^{
//            _thumbImage = resultImage;
//        });
    }
    return _thumbImage;
}

@end

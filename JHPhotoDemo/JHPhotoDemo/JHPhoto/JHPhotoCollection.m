//
//  JHPhotoCollection.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoCollection.h"

@interface JHPhotoCollection()

@property (nonatomic, strong) NSString *collectionName;
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) NSInteger countOfAsset;

@end

@implementation JHPhotoCollection

- (instancetype)initWithPHCollection:(PHAssetCollection *)collection{
    if(self = [super init]){
        self.collection = collection;
    }
    return self;
}

+ (instancetype)collectionWithPHCollection:(PHAssetCollection *)collection{
    JHPhotoCollection *photoCollection = [[JHPhotoCollection alloc]initWithPHCollection:collection];
    return photoCollection;
}
- (void)getThumbImageWithBlock:(void(^)(UIImage *image))block{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.collection options:options];
    if(!result.count){
        if(block){
            block(nil);
        }
        return;
    }
    
    PHAsset *asset = [result objectAtIndex:0];
    CGSize targetSize = CGSizeMake(150, 150);
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if(block){
            block(result);
        }
    }];
}

# pragma mark - Getter and setter
- (NSString *)collectionName{
    if(!_collectionName){
        _collectionName = self.collection.localizedTitle;
    }
    return _collectionName;
}

- (UIImage *)thumbImage{
    if(!_thumbImage){
    }
    return _thumbImage;
}
- (NSInteger)countOfAsset{
    if(!_countOfAsset){
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.collection options:nil];
        _countOfAsset = result.count;
    }
    return _countOfAsset;
}
@end

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

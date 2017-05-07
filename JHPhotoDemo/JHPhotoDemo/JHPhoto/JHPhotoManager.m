//
//  JHPhotoManager.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoManager.h"

@implementation JHPhotoManager

+ (instancetype)maneger{
    static JHPhotoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

# pragma mark - 获取用户是否有访问的权限
+ (BOOL)havePhotoAblumAuthority{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

# pragma mark - 获取用户资源
+ (void)getAllAblumWithCallbackBlock:(JHPhotoManagerCallbackBlock)block{
    if(![JHPhotoManager havePhotoAblumAuthority]){
        // 没有获取访问媒体的权限
        NSError *error = [NSError errorWithDomain:@"NoAuthority" code:403 userInfo:nil];
        NSLog(@"ERROR:没有访问媒体的权限");
        if(block){
            block(nil, error);
        }
        return;
    }
    // 获取所有相册
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSMutableArray *groups = @[].mutableCopy;
    NSArray *collections = @[smartAlbums,userCollections];
    for (PHFetchResult *result in collections)
    {
        for (PHAssetCollection *collection in result)
        {
            if ([collection isKindOfClass:[PHAssetCollection class]])
            {
                    JHPhotoCollection *photoCollection = [JHPhotoCollection collectionWithPHCollection:collection];
                    [groups addObject:photoCollection];
            }
        }
    }
    if(block){
        block(groups, nil);
    }
}

+ (NSArray <JHPHAsset *>*)getPhotosFromCollction:(PHAssetCollection *)collection{
    NSMutableArray *array = [NSMutableArray array];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    for (PHAsset *phAsset in result){
        JHPHAsset *asset = [JHPHAsset assetWithPHAsset:phAsset];
        [array addObject:asset];
    }
    NSLog(@"%@ -- %ld", collection.localizedTitle, result.count);
    return array;
}
+ (NSArray <JHPHAsset *>*)getMediaWithTypes:(NSArray*)typesArray fromCollction:(PHCollection *)collection;{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:options];
    NSMutableArray *array = [NSMutableArray array];
    for (PHAsset *asset in allPhotos){
        JHPHAsset *jhAsset = [JHPHAsset assetWithPHAsset:asset];
        [array addObject:jhAsset];
    }
    return array;
}
+ (void)getAllMediaWithTypes:(NSArray *)typesArray withCallbackBlock:(JHPhotoManagerCallbackBlock)block{
    
}

@end

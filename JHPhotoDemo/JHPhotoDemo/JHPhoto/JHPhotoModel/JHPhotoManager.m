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
/**
 * 获取用户的所有相册
 * @prama: 是否返回空的相册
 */
+ (void)getAllAblumWithCallbackBlock:(JHPhotoManagerCallbackBlock)block withEmpty:(BOOL)empty{
    if(![JHPhotoManager havePhotoAblumAuthority]){
        // 没有获取访问媒体的权限
        NSError *error = [NSError errorWithDomain:@"NoAuthority" code:403 userInfo:nil];
        if(block){
            block(nil, error);
        }
        return;
    }
    // 获取所有相册
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    PHFetchResult *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSMutableArray *groups = [NSMutableArray array];
    NSArray *collections = @[smartAlbums,userCollections];
    for (PHFetchResult *result in collections)
    {
        for (PHCollection *collection in result)
        {
            if ([collection isKindOfClass:[PHAssetCollection class]])
            {
                PHFetchResult *phAsset = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:options];
                if(!phAsset.count && !empty)
                {
                    NSLog(@"%@",((PHAssetCollection *)collection).localizedTitle);
                    continue;
                }
                JHPhotoCollection *photoCollection = [JHPhotoCollection collectionWithPHCollection:(PHAssetCollection *)collection];
                photoCollection.containAsset = phAsset;
                [groups addObject:photoCollection];
            }
        }
    }
    if(block){
        block(groups, nil);
    }
}
/**
 * 获取用户的所有相册
 * 包括空相册
 */
+ (void)getAllAblumWithCallbackBlock:(JHPhotoManagerCallbackBlock)block{
    [JHPhotoManager getAllAblumWithCallbackBlock:block withEmpty:YES];
}

/**
 * 从某个相册里获取所有资源
 */
+ (NSArray <JHPHAsset *>*)getPhotosFromCollction:(JHPhotoCollection *)collection{
    PHFetchResult *result;
    NSMutableArray *array = [NSMutableArray array];
    if(collection.containAsset.count){
        result = collection.containAsset;
    }else{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]];
        result = [PHAsset fetchAssetsInAssetCollection:collection.collection options:options];
    }
    for (PHAsset *phAsset in result){
        JHPHAsset *asset;
        if(phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive){
            asset = [JHPHLivePhotoAsset assetWithPHAsset:phAsset];
        }else if([[phAsset valueForKey:@"filename"] containsString:@".GIF"]){
            asset = [JHPHGifAsset assetWithPHAsset:phAsset];
            // 此处使用了私有的 API， 不保证能上架
            
            // 方法二也是私有 API
            // NSArray *resources = [PHAssetResource assetResourcesForAsset:phAsset];
            // NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
            // }else if([orgFilename containsString:@"gif"]){
            
            // 非私有的方法：[imageManager requestImageDataForAsset:asset]
            // 判断 dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF
        }else{
            asset = [JHPHAsset assetWithPHAsset:phAsset];
        }
        [array addObject:asset];
    }
    return array;
}

/**
 * 获取相册内某个（些）类型的资源
 * 暂不支持
 */
+ (NSArray <JHPHAsset *>*)getMediaWithTypes:(NSArray*)typesArray fromCollction:(JHPhotoCollection *)collection;{
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

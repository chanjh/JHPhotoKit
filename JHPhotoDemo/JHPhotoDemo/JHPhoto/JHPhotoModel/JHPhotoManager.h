//
//  JHPhotoManager.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoHeader.h"

@class JHPHAsset;
@class JHPhotoCollection;
/**
 * 查找结果的回调
 */
typedef void(^JHPhotoManagerCallbackBlock)(NSArray <JHPhotoCollection *> *jhPhotoCollectionArray, NSError *error);

@interface JHPhotoManager : NSObject

# pragma mark - 单例对象
+ (instancetype)maneger;

# pragma mark - 用户权限
/**
 * 判断获取相册的权限
 */
+ (BOOL)havePhotoAblumAuthority;

/**
 * PhotoKit 有两大资源对象
 * PHAsset和PHCollection
 * 前者代表图像或视频对象，
 * 后者是前者的集合或自身类型的集合
 */

# pragma mark - 获取用户数据
// 获取用户的所有相册<包括智能等>
+ (void)getAllAblumWithCallbackBlock:(JHPhotoManagerCallbackBlock)block;

// 获取用户所有某个（些）类型的媒体
+ (void)getAllMediaWithTypes:(NSArray *)typesArray withCallbackBlock:(JHPhotoManagerCallbackBlock)block;

// 获取某个相册下的所有类型的媒体
+ (NSArray <JHPHAsset *> *)getPhotosFromCollction:(PHAssetCollection *)collection;

// 获取某个相册下某个（些）类型的所有媒体
+ (NSArray <JHPHAsset *>*)getMediaWithTypes:(NSArray*)typesArray fromCollction:(PHCollection *)collection;


@property (nonatomic, strong) PHFetchResult *fetchResult;

@end

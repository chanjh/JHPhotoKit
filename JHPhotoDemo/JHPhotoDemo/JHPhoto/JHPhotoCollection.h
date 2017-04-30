//
//  JHPhotoCollection.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoHeader.h"

@interface JHPhotoCollection : NSObject

@property (nonatomic, strong) NSString *collectionName;
@property (nonatomic, strong) PHCollection *collection;

@end

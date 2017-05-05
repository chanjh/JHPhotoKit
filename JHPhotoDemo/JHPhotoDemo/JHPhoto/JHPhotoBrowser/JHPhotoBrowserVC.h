
//  JHPhotoBrowserVC.h
//  PhotoScroll
//
//  Created by 陈嘉豪 on 2017/5/4.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPHAsset.h"

@interface JHPhotoBrowserVC : UICollectionViewController
- (instancetype)initWithIndex:(NSInteger)index;
@property (nonatomic, strong) NSArray <JHPHAsset *> *photoList;

@end

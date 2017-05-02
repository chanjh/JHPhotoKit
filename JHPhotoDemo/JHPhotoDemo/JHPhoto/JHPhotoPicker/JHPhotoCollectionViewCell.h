//
//  JHPhotoCollectionViewCell.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/1.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPhotoCollection.h"
#import "JHPHAsset.h"

@interface JHPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) JHPhotoCollection *collection;
@property (nonatomic, strong) JHPHAsset *photoAsset;

- (void)setCellView;

@end

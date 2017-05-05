//
//  PickerViewController.h
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/5.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHPHAsset;
@interface PickerViewController : UIViewController <UICollectionViewDelegate>
@property (nonatomic, strong) NSArray <JHPHAsset *> *photoList;
@end

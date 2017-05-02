//
//  ViewController.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "ViewController.h"
#import "JHPhotoManager.h"
#import "JHPhotoAblumCollecitonView.h"
#import "JHPhotoPickerColloctionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 相册 collectionView
    __weak typeof(self)weakSelf = self;
    [JHPhotoManager getAllAblumWithCallbackBlock:^(NSArray<JHPhotoCollection *> *jhPhotoCollectionArray, NSError *error) {
        JHPhotoAblumCollecitonView *view = [[JHPhotoAblumCollecitonView alloc]initWithFrame:[UIScreen mainScreen].bounds andPhotoCollection:jhPhotoCollectionArray];
        __weak typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.view addSubview:view];
        });
    }];
    
    // 图片 collectionView
//    NSArray *array = [JHPhotoManager getMediaWithTypes:nil fromCollction:nil];
//    JHPhotoPickerColloctionView *view = [[JHPhotoPickerColloctionView alloc]initWithFrame:[UIScreen mainScreen].bounds andPhotoAssets:array];
//    [self.view addSubview:view];
}


@end

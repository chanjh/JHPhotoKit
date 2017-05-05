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
#import "JHPhotoBrowserVC.h"
#import "PickerViewController.h"

@interface ViewController ()<UICollectionViewDelegate>
@property (nonatomic, strong) NSArray <JHPhotoCollection *> *collectionList;
@property (nonatomic, strong) NSArray <JHPHAsset *> *photoList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JHPhotoDemo";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.collectionList){
        return;
    }
    // 相册 collectionView
    __weak typeof(self)weakSelf = self;
    [JHPhotoManager getAllAblumWithCallbackBlock:^(NSArray<JHPhotoCollection *> *jhPhotoCollectionArray, NSError *error) {
        __weak typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.collectionList = jhPhotoCollectionArray;
        JHPhotoAblumCollecitonView *view = [[JHPhotoAblumCollecitonView alloc]initWithFrame:self.view.frame andPhotoCollection:jhPhotoCollectionArray];
        view.collectionView.delegate = self;
        [view setTag:100];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.view addSubview:view];
        });
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 图片 collectionView
    NSArray *array = [JHPhotoManager getPhotosFromCollction:self.collectionList[indexPath.row].collection];
    self.photoList = array;
    JHPhotoPickerColloctionView *view = [[JHPhotoPickerColloctionView alloc]initWithFrame:[UIScreen mainScreen].bounds andPhotoAssets:array];
    
    PickerViewController *vc = [[PickerViewController alloc]init];
    [vc.view addSubview:view];
    view.collectionView.delegate = vc;
    vc.photoList = self.photoList;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end

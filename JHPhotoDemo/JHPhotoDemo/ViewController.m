//
//  ViewController.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/4/30.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "ViewController.h"
#import "JHPhotoManager.h"
#import "JHPhotoAblumCollecitonVC.h"

@interface ViewController ()<UICollectionViewDelegate>
@property (nonatomic, strong) NSArray <JHPhotoCollection *> *collectionList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JHPhotoDemo";
}

- (IBAction)enterAction:(id)sender
{
    if(self.collectionList){
        JHPhotoAblumCollecitonVC *view = [[JHPhotoAblumCollecitonVC alloc]initWithFrame:self.view.frame andPhotoCollection:self.collectionList];
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [JHPhotoManager getAllAblumWithCallbackBlock:^(NSArray<JHPhotoCollection *> *jhPhotoCollectionArray, NSError *error) {
        __weak typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.collectionList = jhPhotoCollectionArray;
        JHPhotoAblumCollecitonVC *view = [[JHPhotoAblumCollecitonVC alloc]initWithFrame:self.view.frame andPhotoCollection:jhPhotoCollectionArray];
        [strongSelf.navigationController pushViewController:view animated:YES];
    }];
}

@end

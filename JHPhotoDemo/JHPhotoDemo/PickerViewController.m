//
//  PickerViewController.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/5.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "PickerViewController.h"
#import "JHPhotoBrowserVC.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JHPhotoBrowserVC *vc = [[JHPhotoBrowserVC alloc]init];
    vc.photoList = self.photoList;
    [self.navigationController pushViewController:vc animated:YES];

}

@end

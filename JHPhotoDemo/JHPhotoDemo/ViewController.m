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
#import <PhotosUI/PhotosUI.h>

//@import Photos;
//@import PhotosUI;
@import MobileCoreServices;

@interface ViewController ()<UICollectionViewDelegate,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            PHLivePhotoViewDelegate>
@property (nonatomic, strong) NSArray <JHPhotoCollection *> *collectionList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JHPhotoDemo";
    // 方便调试……
    [self enterAction:nil];
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
        JHPhotoAblumCollecitonVC *vc = [[JHPhotoAblumCollecitonVC alloc]initWithFrame:self.view.frame andPhotoCollection:jhPhotoCollectionArray];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];
}
- (IBAction)pickerAction:(id)sender {
    
    // create an image picker
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    // make sure we include Live Photos (otherwise we'll only get UIImages)
    NSArray *mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto];
    picker.mediaTypes = mediaTypes;
    
    // bring up the picker
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 网络上找来，用 UIImagePicker 展示 Live Photo 的方法
    // dismiss the picker
    [self dismissViewControllerAnimated:YES completion:nil];
    // if we have a live photo view already, remove it
    if ([self.view viewWithTag:87]) {
        UIView *subview = [self.view viewWithTag:87];
        [subview removeFromSuperview];
    }
    // check if this is a Live Image, otherwise present a warning
    PHLivePhoto *photo = [info objectForKey:UIImagePickerControllerLivePhoto];
    if (!photo) {
        
        return;
    }
    // create a Live Photo View
    PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
    photoView.livePhoto = [info objectForKey:UIImagePickerControllerLivePhoto];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    photoView.tag = 87;
}
@end

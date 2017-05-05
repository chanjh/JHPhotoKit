//
//  JHPhotoCollectionViewCell.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/1.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoCollectionViewCell.h"
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
@interface JHPhotoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *ablumNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ablumImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualView;

@end

@implementation JHPhotoCollectionViewCell

- (void)setCellView{
    if(self.collection){
        [self.ablumNameLabel setText:self.collection.collectionName];
        [self.numLabel setText:[NSString stringWithFormat:@"%ld", (long)self.collection.countOfAsset]];
        [self.collection getThumbImageWithBlock:^(UIImage *image) {
            [self.ablumImageView setImage:image];
        }];
        return;
    }else if(self.photoAsset) {
        [self.visualView setHidden:YES];
        [self.ablumNameLabel setHidden:YES];
        [self.numLabel setHidden:YES];
        [self.photoAsset getThumbImageWithBlock:^(UIImage *image) {
            [self.ablumImageView setImage:image];
        }];
    }
}

@end

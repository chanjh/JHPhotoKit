//
//  JHAblumCollectionViewCell.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/1.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHAblumCollectionViewCell.h"

@interface JHAblumCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *ablumNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ablumImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end


@implementation JHAblumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self.ablumNameLabel setText:self.collection.collectionName];
    [self.numLabel setText:[NSString stringWithFormat:@"%ld", self.collection.countOfAsset]];
    [self.ablumImageView setImage:self.collection.thumbImage];
}

@end

//
//  JHPhotoAblumCollecitonView.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/1.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoAblumCollecitonView.h"
#import "JHAblumCollectionViewCell.h"
#define DeviceSize [UIScreen mainScreen].bounds.size

@interface JHPhotoAblumCollecitonView()<UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <JHPhotoCollection *> *photoCollectionList;

@end

@implementation JHPhotoAblumCollecitonView

- (instancetype)initWithFrame:(CGRect)frame andPhotoCollection:(NSArray <JHPhotoCollection *> *)collectionList{
    if(self = [super initWithFrame:frame]){
        self.photoCollectionList = collectionList;
        [self setFrame:frame];
        [self collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        // 设置流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 定义大小
        layout.itemSize = CGSizeMake(100, 100);
        // 设置最小行间距(上下的间距)
        layout.minimumLineSpacing = 40;
        // 设置垂直间距(左右的间距)
        layout.minimumInteritemSpacing = 2;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"JHAblumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JHAblumCollectionViewCellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

# pragma mark - UICollectionDelegate UICollectionDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHAblumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHAblumCollectionViewCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    NSLog(@"%ld", indexPath.row);
    cell.collection = self.photoCollectionList[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoCollectionList.count;
}


@end

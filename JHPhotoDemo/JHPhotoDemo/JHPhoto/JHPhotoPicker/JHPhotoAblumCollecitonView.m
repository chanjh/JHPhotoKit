//
//  JHPhotoAblumCollecitonView.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/1.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoAblumCollecitonView.h"
#import "JHPhotoCollectionViewCell.h"
#define DeviceSize [UIScreen mainScreen].bounds.size

@interface JHPhotoAblumCollecitonView()<UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout>

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
# pragma mark - Getter and setter
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat cellW = (screenSize.width - 2*3)/2;
        // 定义大小
        layout.itemSize = CGSizeMake(cellW, cellW);
        // 设置最小行间距(上下的间距)
        layout.minimumLineSpacing = 2;
        // 设置垂直间距(左右的间距)
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"JHPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JHPhotoCollectionViewCellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

# pragma mark - UICollectionDelegate UICollectionDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHPhotoCollectionViewCellID" forIndexPath:indexPath];
    cell.collection = self.photoCollectionList[indexPath.row];
    [cell setCellView];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoCollectionList.count;
}


@end

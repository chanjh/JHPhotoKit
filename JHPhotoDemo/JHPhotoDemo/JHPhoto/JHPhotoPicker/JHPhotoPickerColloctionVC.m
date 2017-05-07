//
//  JHPhotoPickerColloctionVC.m
//  JHPhotoDemo
//
//  Created by 陈嘉豪 on 2017/5/7.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoPickerColloctionVC.h"
#import "JHPhotoCollectionViewCell.h"
#import "JHPhotoBrowserVC.h"

@interface JHPhotoPickerColloctionVC ()<UICollectionViewDelegate>
@property (nonatomic, strong) JHPhotoPickerColloctionView *pickerView;
@end

@implementation JHPhotoPickerColloctionVC
- (instancetype)initWithFrame:(CGRect)frame andPhotoAssets:(NSArray<JHPHAsset *> *)assetList{
    if(self = [super init]){
        self.pickerView = [[JHPhotoPickerColloctionView alloc]initWithFrame:frame andPhotoAssets:assetList];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.pickerView){
        [self.view addSubview:self.pickerView];
        self.pickerView.collectionView.delegate = self;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JHPhotoBrowserVC *vc = [[JHPhotoBrowserVC alloc]initWithIndex:indexPath.row];
    vc.photoList = self.pickerView.assetList;
    [self.navigationController pushViewController:vc animated:YES];
}
@end



/*
 * JHPhotoPickerColloctionView
 */
# pragma mark - JHPhotoPickerColloctionView
@interface JHPhotoPickerColloctionView()<UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray <JHPHAsset *> *assetList;

@end

@implementation JHPhotoPickerColloctionView

- (instancetype)initWithFrame:(CGRect)frame andPhotoAssets:(NSArray<JHPHAsset *> *)assetList{
    if(self = [super initWithFrame:frame]){
        self.assetList = assetList;
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
        CGFloat cellW = (screenSize.width - 2*3)/4;
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
    cell.photoAsset = self.assetList[indexPath.row];
    [cell setCellView];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetList.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(didSelectAtIndex:)]){
        [self.delegate didSelectAtIndex:indexPath.row];
    }
}

@end



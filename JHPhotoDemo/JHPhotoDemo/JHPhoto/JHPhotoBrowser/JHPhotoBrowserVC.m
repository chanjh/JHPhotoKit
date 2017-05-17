//
//  JHPhotoBrowserVC.m
//  PhotoScroll
//
//  Created by 陈嘉豪 on 2017/5/4.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoBrowserVC.h"
#import "JHPhotoBrowserView.h"

typedef NS_ENUM(NSUInteger, JHPhotoBrowserGestureType) {
    JHPhotoBrowserGestureTypeNone,
    JHPhotoBrowserGestureTypeScroll,
    JHPhotoBrowserGestureTypeCancel,
};

@interface JHPhotoBrowserVC ()<UIGestureRecognizerDelegate, JHPhotoBrowserViewDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) JHPhotoBrowserGestureType gestureType;
@end

@implementation JHPhotoBrowserVC

# pragma mark - 初始化
static NSString * const reuseIdentifier = @"Cell";
- (instancetype)initWithIndex:(NSInteger)index{
    self = [self init];
    self.index = index;
    return self;
}
- (instancetype)init{
    if(self = [super init]){
        [self setupCollectionView];
        self.index = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView setContentOffset:CGPointMake(self.view.frame.size.width * self.index, 0)];
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    layout.itemSize = CGSizeMake(screenSize.width, screenSize.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) collectionViewLayout:layout];
    [self.collectionView registerClass:[JHPhotoBrowserView class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = FALSE;
    self.collectionView.showsHorizontalScrollIndicator = FALSE;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - UICollectionViewDataSource、Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHPhotoBrowserView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setViewWithAsset:self.photoList[indexPath.row]];
    return cell;
}
/**
 * 移除 cell 的所有手势
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    for (UIGestureRecognizer *gestureRecognizer in cell.gestureRecognizers){
        [cell removeGestureRecognizer:gestureRecognizer];
    }
}
/**
 * 重新添加手势
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    // 慢滑手势
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]init];
    recognizer.delegate = cell;
    [recognizer addTarget:cell action:@selector(handleGestureRecognizer:)];
    [cell addGestureRecognizer:recognizer];
}

# pragma mark - JHPhotoBrowserViewDelegate
- (void)viewShouldDismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

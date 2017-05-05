//
//  JHPhotoBrowserVC.m
//  PhotoScroll
//
//  Created by 陈嘉豪 on 2017/5/4.
//  Copyright © 2017年 陈嘉豪. All rights reserved.
//

#import "JHPhotoBrowserVC.h"
#import "JHPhotoBrowserView.h"

@interface JHPhotoBrowserVC ()
@end

@implementation JHPhotoBrowserVC

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init{
    if(self = [super init]){
        [self setupCollectionView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    layout.itemSize = CGSizeMake(screenSize.width, screenSize.height);
    // 设置最小行间距(上下的间距)
    layout.minimumLineSpacing = 0;
    // 设置垂直间距(左右的间距)
    layout.minimumInteritemSpacing = 0;
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) collectionViewLayout:layout];
    [self.collectionView registerClass:[JHPhotoBrowserView class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHPhotoBrowserView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [self.photoList[indexPath.row] getOriginImageWithBlock:^(UIImage *image) {
        [cell setImageWithImage:image];
    }];
    return cell;
}

# pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld", (long)indexPath.row);
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSLog(@"here");
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
}
# pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f", scrollView.contentOffset.x);
}

@end

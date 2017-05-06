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

@interface JHPhotoBrowserVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) JHPhotoBrowserGestureType gestureType;
@end

@implementation JHPhotoBrowserVC{
    CGRect _firstFrame;             // 手势启动时，图层的位置
}

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

#pragma mark UICollectionViewDataSource、Delegate
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
    recognizer.delegate = self;
    [recognizer addTarget:self action:@selector(handleGestureRecognizer:)];
    [cell addGestureRecognizer:recognizer];
    
    // 快扫手势
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]init];
    swipeRecognizer.numberOfTouchesRequired = 1;
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    swipeRecognizer.delegate = self;
    [cell addGestureRecognizer:swipeRecognizer];

}
# pragma mark - Gesture Handler
- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        // 手势一开始移动时，图层的位置
        _firstFrame = recognizer.view.frame;
    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        // 图片跟着手势移动
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
        [recognizer.view setFrame:CGRectMake(_firstFrame.origin.x + [panGestureRecognizer translationInView:self.collectionView].x , _firstFrame.origin.y + [panGestureRecognizer translationInView:self.collectionView].y, _firstFrame.size.width, _firstFrame.size.height)];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        // 结束手势
        self.gestureType = JHPhotoBrowserGestureTypeNone;
        [recognizer.view setFrame:_firstFrame];
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
        [panGestureRecognizer setTranslation:CGPointZero inView:recognizer.view];
        [self dismissVC];
    }
}

- (void)dismissVC{
    
}

# pragma mark - UIGestureDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [panGestureRecognizer translationInView:gestureRecognizer.view];
        // 速度
//        NSLog(@"X :%f",[panGestureRecognizer velocityInView:gestureRecognizer.view].x);
//        NSLog(@"Y :%f",[panGestureRecognizer velocityInView:gestureRecognizer.view].y);
        // 位移
//        NSLog(@"X :%f",[panGestureRecognizer translationInView:gestureRecognizer.view].x);
//        NSLog(@"Y :%f",[panGestureRecognizer translationInView:gestureRecognizer.view].y);
        if(fabs(point.y) >= fabs(point.x) && self.gestureType == JHPhotoBrowserGestureTypeNone){
            // 用于移动图片图层
            self.gestureType = JHPhotoBrowserGestureTypeCancel;
            return YES;
        }else if(fabs(point.y) < fabs(point.x) && self.gestureType == JHPhotoBrowserGestureTypeNone){
            // 滚动图片背后的 collectionView 图层
            self.gestureType = JHPhotoBrowserGestureTypeNone;
            UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
            [panGestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
            return NO;
        }
    }else{
        // 快扫手势
    }
    return YES;
}

@end

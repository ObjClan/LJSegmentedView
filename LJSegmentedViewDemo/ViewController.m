//
//  ViewController.m
//  test
//
//  Created by object_lan on 2017/5/31.
//  Copyright © 2017年 object_lan. All rights reserved.
//

#import "ViewController.h"
#import "LJSegmentedView.h"

@interface ViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong)LJSegmentedView *segmentedView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.dataArray = [NSMutableArray array];

    for (int i = 0; i < 20; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"菜单%d",i]];
    }
    
    [self.view addSubview:self.segmentedView];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

//懒加载segmentedView
-(LJSegmentedView *)segmentedView
{
    if (!_segmentedView) {
        _segmentedView = [[LJSegmentedView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.frame), 50)];
        _segmentedView.itemTitles = self.dataArray;
        _segmentedView.fixed = NO;
        [_segmentedView selectItemWithIndex:0];
        _segmentedView.itemWidth = CGRectGetWidth(self.view.frame) / 4.5;
        _segmentedView.itemBackgroundColorNormal = [UIColor whiteColor];
        _segmentedView.itemBackgroundColorSelected = [UIColor whiteColor];
        _segmentedView.itemTitleColorNormal = [UIColor blackColor];
        _segmentedView.itemTitleColorSelected = [UIColor orangeColor];
        _segmentedView.itemTitleFontNormal = [UIFont systemFontOfSize:16];
        _segmentedView.itemTitleFontSelected = [UIFont systemFontOfSize:20];
        _segmentedView.selectedLineColor = [UIColor orangeColor];
        __weak typeof(self)weakSelf = self;
        _segmentedView.itemSelectBlock = ^(NSInteger index) {
            weakSelf.collectionView.contentOffset = CGPointMake(index * CGRectGetWidth(self.view.frame), 0);
        };
    }
    return _segmentedView;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //滚动方向
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        //行间距
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.segmentedView.frame));
        _collectionView.backgroundColor = [UIColor whiteColor];
        //不显示水平滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        //取消弹簧
        _collectionView.bounces = NO;
        
        //注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    //防止cell的subView重复添加
    UILabel *titleLab = (UILabel *)[cell viewWithTag:4253];
    if (!titleLab) {
        titleLab = [UILabel new];
        titleLab.tag = 4253;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.frame = CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
        [cell addSubview:titleLab];
    }
    
    //重设cell数据
    titleLab.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
    titleLab.text = [NSString stringWithFormat:@"第%ld页",indexPath.row];
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
}


//当scrollView停止滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    [self.segmentedView selectItemWithIndex:[@(index) integerValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.segmentedView = nil;
    self.collectionView = nil;
    self.dataArray = nil;
}

@end

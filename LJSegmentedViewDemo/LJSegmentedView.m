//
//  LJSegmentedView.m
//  test
//
//  Created by object_lan on 2017/6/1.
//  Copyright © 2017年 object_lan. All rights reserved.
//

#import "LJSegmentedView.h"

@interface LJSegmentedView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIView *selectedLine;                 //被选中cell下标线
@property (nonatomic, assign)NSInteger selectedIndex;              //当前选中的item的索引
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;       //当前选中cell的indexpath
@end
@implementation LJSegmentedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews
{
    [self addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
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
        //不显示水平滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        //取消弹簧
        _collectionView.bounces = NO;

        //创建下标线
        [_collectionView addSubview:self.selectedLine];
        //注册cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"segmentedViewCell"];
    }
    _collectionView.backgroundColor = self.itemBackgroundColorNormal;
    return _collectionView;
}

-(NSIndexPath *)selectedIndexPath
{
    if (!_selectedIndexPath) {
        _selectedIndexPath =  [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    }
    return _selectedIndexPath;
}
-(UIView *)selectedLine
{
    if (!_selectedLine) {
        _selectedLine = [[UIView alloc] init];
    }
    _selectedLine.backgroundColor = self.selectedLineColor;
    return _selectedLine;
}
-(CGFloat)cellWidth
{
    if (self.fixed) {
        _itemWidth = CGRectGetWidth(self.frame) / [self.collectionView numberOfItemsInSection:0];
    }
    return _itemWidth;
}


-(void)layoutSubviews
{
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame));
    self.selectedLine.frame = CGRectMake(0, CGRectGetHeight(self.collectionView.frame) - 3, self.cellWidth, 3);
}


-(void)selectItemWithIndex:(NSInteger)index
{
    self.selectedIndex = index;
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemTitles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"segmentedViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    //防止cell的subView重复添加
    UILabel *titleLab = (UILabel *)[cell viewWithTag:45234];
    if (!titleLab) {
        titleLab = [UILabel new];
        titleLab.tag = 45234;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.frame = CGRectMake(0, 0, self.cellWidth, CGRectGetHeight(collectionView.frame));
        [cell addSubview:titleLab];
    }
    
    //重设cell数据
    titleLab.text = self.itemTitles[indexPath.row];
    if (self.selectedIndexPath == indexPath) {
        titleLab.textColor = self.itemTitleColorSelected;
        titleLab.backgroundColor = self.itemBackgroundColorSelected;
        titleLab.font = self.itemTitleFontSelected;
    } else {
        titleLab.textColor = self.itemTitleColorNormal;
        titleLab.backgroundColor = self.itemBackgroundColorNormal;
        titleLab.font = self.itemTitleFontNormal;
    }
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.cellWidth, CGRectGetHeight(collectionView.frame));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //上一次选中的cell
    UICollectionViewCell *lastSelectCell = [collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    UILabel *lab = (UILabel *)[lastSelectCell viewWithTag:45234];
    lab.textColor = self.itemTitleColorNormal;
    lab.backgroundColor = self.itemBackgroundColorNormal;
    lab.font = self.itemTitleFontNormal;
    //当前选中的cell
    UICollectionViewCell *currentSelectCell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *selectedLab = (UILabel *)[currentSelectCell viewWithTag:45234];
    selectedLab.textColor = self.itemTitleColorSelected;
    selectedLab.backgroundColor = self.itemBackgroundColorSelected;
    selectedLab.font = self.itemTitleFontSelected;
    
    self.selectedIndexPath = indexPath;
    
    //重置offset
    [UIView animateWithDuration:0.2 animations:^{
        [self setOffsetOfSegmentedViewWithIndex:indexPath.row];
    } completion:^(BOOL finished) {
        
    }];
    
    //重置下标线的frame
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedLine.frame = CGRectMake(self.cellWidth * indexPath.row, CGRectGetMinY(self.selectedLine.frame), CGRectGetWidth(self.selectedLine.frame), CGRectGetHeight(self.selectedLine.frame));
    } completion:^(BOOL finished) {
        
    }];
    if (self.itemSelectBlock) {
        self.itemSelectBlock(indexPath.row);
    }
}

-(void)setOffsetOfSegmentedViewWithIndex:(NSInteger)index;
{
    //每页显示item个数，可能为小数
    CGFloat count = self.collectionView.frame.size.width / self.itemWidth;
    
    if (index <= [@(count / 2) integerValue]) {
        self.collectionView.contentOffset = CGPointMake(0, 0);
    } else {
        self.collectionView.contentOffset = CGPointMake((index - [@(count / 2) integerValue]) * self.itemWidth, 0);
    }
    
    
    //计算collectionView最大的offset值
    CGFloat maxOffsetX = ([self.collectionView numberOfItemsInSection:0] - count) * self.itemWidth;
    
    //不能超过最大offset
    if (self.collectionView.contentOffset.x > maxOffsetX) {
        self.collectionView.contentOffset = CGPointMake(maxOffsetX, 0);
    }
    
}
-(void)reloadSegmentedView
{
    [self.collectionView reloadData];
}
-(void)dealloc
{
    self.collectionView = nil;
    self.selectedLine = nil;
    self.selectedIndexPath = nil;
    self.itemTitles = nil;
}

@end



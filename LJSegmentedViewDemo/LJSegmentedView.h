//
//  LJSegmentedView.h
//  test
//
//  Created by object_lan on 2017/6/1.
//  Copyright © 2017年 object_lan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemSelectBlock)(NSInteger);

@interface LJSegmentedView : UIView
//存放每个item的标题
@property (nonatomic, strong)NSArray *itemTitles;
//item数目较少不需要时滚动设为YES，否则为NO。
@property (nonatomic, assign, getter=isFixed)BOOL fixed;
//被选中item的背景色
@property (nonatomic, strong)UIColor *itemBackgroundColorSelected;
//未选中item的背景色
@property (nonatomic, strong)UIColor *itemBackgroundColorNormal;
//被选中item标题文字颜色
@property (nonatomic, strong)UIColor *itemTitleColorSelected;
//未选中item标题文字颜色
@property (nonatomic, strong)UIColor *itemTitleColorNormal;
//被选中item标题文字字体
@property (nonatomic, strong)UIFont *itemTitleFontSelected;
//未选中item标题文字字体
@property (nonatomic, strong)UIFont *itemTitleFontNormal;
//下标线颜色;
@property (nonatomic, strong)UIColor *selectedLineColor;
//每个item的宽度，fixed为YES时无效。
@property (nonatomic, assign)CGFloat itemWidth;

//item点击回调
@property (nonatomic, strong)ItemSelectBlock itemSelectBlock;

//手动选中某个item
-(void)selectItemWithIndex:(NSInteger)index;
//刷新
-(void)reloadSegmentedView;
@end

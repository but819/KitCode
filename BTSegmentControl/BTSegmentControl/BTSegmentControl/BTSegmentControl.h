//
//  BTSegmentControl.h
//  BTSegmentControl
//
//  Created by 罗锦伟 on 15/12/6.
//  Copyright © 2015年 but819. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTSegmentControl;

@protocol BTSegmentControlDelegate <NSObject>

//点击回调方法
- (void)segmentControl:(BTSegmentControl *)segment didSelectedWithIndex:(NSInteger)index;

@end

@interface BTSegmentControl : UIView

//是否嵌入到滑动视图使用
@property (nonatomic, assign) BOOL isUseForScrollView;

//整体背景颜色
@property (nonatomic, strong) UIColor *totalViewBackgroundColor;

//按钮默认字体颜色
@property (nonatomic, strong) UIColor *normalBtnTextColor;

//按钮默认背景颜色
@property (nonatomic, strong) UIColor *normalBtnBackgroundColor;

//按钮点击字体颜色
@property (nonatomic, strong) UIColor *selectBtnTextColor;

//按钮点击视图背景颜色
@property (nonatomic, strong) UIColor *selectBtnViewBackgroundColor;

//代理
@property (nonatomic, weak) id<BTSegmentControlDelegate> delegate;

//标题数组
@property (nonatomic, strong) NSArray *totalBtnTitleArray;

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame AndTitleArray:(NSArray *)titleArray;

//手动切换按钮方法
- (void)setSelectedWithIndex:(NSInteger)index;

//滑动更新控件视图
- (void)scrollSelectBtnViewWithXPosition:(CGFloat)xPosition MinX:(CGFloat)minX AndMaxX:(CGFloat)maxX;

@end


//
//  BTSegmentControl.m
//  BTSegmentControl
//
//  Created by 罗锦伟 on 15/12/6.
//  Copyright © 2015年 but819. All rights reserved.
//

#import "BTSegmentControl.h"

#define maxScale 1.25

#define minScale 1.00

#define selfViewWidth self.frame.size.width

#define selfViewHeight self.frame.size.height

#define defaultTotalViewBackgroundColor [UIColor colorWithRed:112.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1.0]

#define defaultNormalBtnTextColor [UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:245.0/255.0 alpha:1.0]

#define defaultNormalBtnBackgroundColor [UIColor colorWithRed:112.0/255.0 green:128.0/255.0 blue:144.0/255.0 alpha:1.0]

#define defaultSelectBtnTextColor [UIColor colorWithRed:255.0/255.0 green:20.0/255.0 blue:147.0/255.0 alpha:1.0]

#define defaultSelectBtnViewBackgroundColor [UIColor colorWithRed:176.0/255.0 green:196.0/255.0 blue:222.0/255.0 alpha:1.0]

@implementation BTSegmentControl
{
    //按钮宽度
    CGFloat btnWidth;
    
    //指示视图
    UIView *selectBtnView;
    
    //指示视图当前所在的按钮
    UIButton *currentBtn;
    
    //当前按钮下标
    NSInteger currentBtnIndex;
    
    //按钮总数
    NSUInteger totalBtnCount;
    
    //按钮数组
    NSMutableArray *totalButtonArray;
    
    //按钮动画数组
    NSMutableArray *totalButtonTransformArray;

    //指示视图所在位置第一个按钮
    UIButton *firstBtnOnselectBtnView;
    
    //指示视图所在位置第二个按钮
    UIButton *secondBtnOnselectBtnView;
}

@synthesize totalViewBackgroundColor  =_totalViewBackgroundColor;

@synthesize normalBtnTextColor  =_normalBtnTextColor;

@synthesize normalBtnBackgroundColor  =_normalBtnBackgroundColor;

@synthesize selectBtnTextColor  =_selectBtnTextColor;

@synthesize selectBtnViewBackgroundColor  =_selectBtnViewBackgroundColor;

#pragma mark -
#pragma mark ------------ Init ------------

//初始化方法
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.totalBtnTitleArray =@[@"title",@"title",@"title"];
        //初始化数据
        [self initData];
        
        //初始化视图
        [self initView];
    }
    return self;
}

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame AndTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.totalBtnTitleArray =titleArray;
        //初始化数据
        [self initData];
        
        //初始化视图
        [self initView];
    }
    return self;
}

//初始化数据
-(void)initData
{
    totalBtnCount=self.totalBtnTitleArray.count;
    
    btnWidth =  selfViewWidth/ totalBtnCount;
    
    totalButtonArray =[[NSMutableArray alloc] init];
    
    totalButtonTransformArray =[[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark ------------ Layout ------------

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self resetViewFrame];
}

#pragma mark -
#pragma mark ------------ property------------

//整体背景颜色
-(UIColor *)totalViewBackgroundColor
{
    if (_totalViewBackgroundColor ==nil) {
        _totalViewBackgroundColor =defaultTotalViewBackgroundColor;
    }
    return _totalViewBackgroundColor;
}

- (void)setTotalViewBackgroundColor:(UIColor *)totalViewBackgroundColor
{
    if (totalViewBackgroundColor ==nil) {
        return;
    }
    _totalViewBackgroundColor=totalViewBackgroundColor;
    [self setBackgroundColor:totalViewBackgroundColor];
}

//按钮默认字体颜色
-(UIColor *)normalBtnTextColor
{
    if (_normalBtnTextColor ==nil) {
        _normalBtnTextColor =defaultNormalBtnTextColor;
    }
    return _normalBtnTextColor;
}

- (void)setNormalBtnTextColor:(UIColor *)normalBtnTextColor
{
    if (normalBtnTextColor ==nil) {
        return;
    }
    _normalBtnTextColor=normalBtnTextColor;
    for (UIButton *btn in totalButtonArray) {
        [btn setTitleColor:normalBtnTextColor forState:UIControlStateNormal];
    }
}

//按钮默认背景颜色
-(UIColor *)normalBtnBackgroundColor
{
    if (_normalBtnBackgroundColor ==nil) {
        _normalBtnBackgroundColor =defaultNormalBtnBackgroundColor;
    }
    return _normalBtnBackgroundColor;
}

- (void)setNormalBtnBackgroundColor:(UIColor *)normalBtnBackgroundColor
{
    if (normalBtnBackgroundColor ==nil) {
        return;
    }
    _normalBtnBackgroundColor=normalBtnBackgroundColor;
}

//按钮点击字体颜色
-(UIColor *)selectBtnTextColor
{
    if (_selectBtnTextColor ==nil) {
        _selectBtnTextColor =defaultSelectBtnTextColor;
    }
    return _selectBtnTextColor;
}

- (void)setSelectBtnTextColor:(UIColor *)selectBtnTextColor
{
    if (selectBtnTextColor ==nil) {
        return;
    }
    _selectBtnTextColor =selectBtnTextColor;
    [currentBtn setTitleColor:selectBtnTextColor forState:UIControlStateNormal];
}

//按钮点击视图背景颜色
-(UIColor *)selectBtnViewBackgroundColor
{
    if (_selectBtnViewBackgroundColor ==nil) {
        _selectBtnViewBackgroundColor =defaultSelectBtnViewBackgroundColor;
    }
    return _selectBtnViewBackgroundColor;
}

- (void)setSelectBtnViewBackgroundColor:(UIColor *)selectBtnViewBackgroundColor
{
    if (selectBtnViewBackgroundColor ==nil) {
        return;
    }
    _selectBtnViewBackgroundColor=selectBtnViewBackgroundColor;
    [selectBtnView setBackgroundColor:selectBtnViewBackgroundColor];
}

#pragma mark -
#pragma mark ------------ Init Ui------------

//初始化视图
-(void)initView
{
    //整体view调整
    self.layer.cornerRadius  = 5;
    self.layer.masksToBounds = YES;
    [self setBackgroundColor:self.totalViewBackgroundColor];
    
    //创建指示视图
    selectBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, selfViewHeight-2, btnWidth, 2)];
    selectBtnView.backgroundColor = self.selectBtnViewBackgroundColor;
    selectBtnView.layer.cornerRadius = self.layer.cornerRadius;
    selectBtnView.layer.masksToBounds = YES;
    [self addSubview:selectBtnView];
    
    //动态创建所有按钮
    for (int i = 0; i < totalBtnCount; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag=i+1;
        btn.frame = CGRectMake(btnWidth * i, 0, btnWidth, selfViewHeight);
        btn.titleLabel.font =[UIFont systemFontOfSize: 15.0];
        [btn setTitle:self.totalBtnTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.normalBtnTextColor forState:UIControlStateNormal];
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [totalButtonArray addObject:btn];
        
        CATransform3D btnTransform =btn.layer.transform;
        [totalButtonTransformArray addObject:[NSValue valueWithBytes:&btnTransform objCType:@encode(CATransform3D)]];
    }
    
    //提取第一个按钮
    currentBtnIndex=0;
    currentBtn = (UIButton *)totalButtonArray[currentBtnIndex];
    [currentBtn setTitleColor:self.selectBtnTextColor forState:UIControlStateNormal];
    currentBtn.transform = CGAffineTransformScale(currentBtn.transform, maxScale, maxScale);
}

#pragma mark -
#pragma mark ------------ Action ------------

//按钮点击事件
-(void)itemBtnClick:(UIButton *)btn
{
    //通过按钮计算下标
    NSInteger index = (NSInteger)btn.tag-1;
    //切换操作
    [self setSelectedWithIndex:index];
}

#pragma mark -
#pragma mark ------------ Function ------------

-(void)resetViewFrame
{
    //重新计算宽度
    btnWidth =  selfViewWidth/ totalBtnCount;

    //调整指示视图位置
    selectBtnView.frame=CGRectMake(selectBtnView.frame.origin.x, selfViewHeight-2, btnWidth, 2);
    
    //提取按钮
    UIButton *indexBtn;
    //动态创建所有按钮
    for (int i = 0; i < totalBtnCount; i++)
    {
        indexBtn=totalButtonArray[i];
        indexBtn.frame = CGRectMake(btnWidth * i, 0, btnWidth, selfViewHeight);
    }
    indexBtn=nil;
}

#pragma mark -
#pragma mark ------------ Animate ------------

//动画开始跟结束的额外操作
-(void)handleItemClickAnimateWithisStart:(BOOL)isStart AndIndex:(NSInteger)index
{
    //指示视图位置只改变一次
    if (isStart) {
        selectBtnView.frame = CGRectMake(btnWidth * index, selfViewHeight-selectBtnView.frame.size.height, selectBtnView.frame.size.width, selectBtnView.frame.size.height);
    }
    //根据状态提取按钮
    currentBtn = isStart?currentBtn:totalButtonArray[index];
    
    //根据状态设置按钮字体样式
    [currentBtn setTitleColor:isStart?self.normalBtnTextColor:self.selectBtnTextColor forState:UIControlStateNormal];
    
    //根据状态执行动画
    currentBtn.transform = isStart?CGAffineTransformIdentity:CGAffineTransformScale(currentBtn.transform, maxScale, maxScale);
}

#pragma mark -
#pragma mark ------------ Function ------------

//手动切换按钮方法
- (void)setSelectedWithIndex:(NSInteger)index
{
    //回调操作
    if ([self.delegate respondsToSelector:@selector(segmentControl:didSelectedWithIndex:)]) {
        [self.delegate segmentControl:self didSelectedWithIndex:index];
    }
    
    //如果结合scrollView使用则不改变指示图
    if (self.isUseForScrollView) {
        return;
    }
    
    //处理过渡
    [UIView animateWithDuration:0.25f animations:^{
        //设为未选中
        [self handleItemClickAnimateWithisStart:YES AndIndex:index];
        //设为选中
        [self handleItemClickAnimateWithisStart:NO  AndIndex:index];
    } completion:^(BOOL finished) {
    }];
}

//滑动点击视图
- (void)scrollSelectBtnViewWithXPosition:(CGFloat)xPosition MinX:(CGFloat)minX AndMaxX:(CGFloat)maxX
{
    //停止按钮点击滑动效果
     self.isUseForScrollView=YES;
    
    //计算滑动占比
    CGFloat ratio=xPosition/(maxX-minX);
    
    //换算比例
    CGFloat newXPosition= ((totalBtnCount-1)*btnWidth-0)*ratio+0;
    
    //获取指示器当前位置
    CGRect frame = selectBtnView.frame;
    
    //控制在整个视图范围内
    if (newXPosition >= 0 && newXPosition <= (totalBtnCount-1)*btnWidth) {
        frame.origin = CGPointMake(newXPosition, selfViewHeight-2);
    }
    //重新赋值
    selectBtnView.frame = frame;
    
    [self updateTotalBtnIsByScroll:YES];
}

//更新滑动过的按钮
-(void)updateTotalBtnIsByScroll:(BOOL)isByScroll
{
    //最新位置
    CGFloat nowSelectBtnViewPlace=selectBtnView.frame.origin.x;
    
    CGFloat firstScale,secondScale;
    
    NSInteger firstIndex,secondIndex;
    
    CATransform3D firstBtnOnselectBtnViewTransform,secondBtnOnselectBtnViewTransform;

    //提取按钮
    if (isByScroll) {
        //提取第一个按钮
        firstIndex =nowSelectBtnViewPlace/btnWidth;
        firstBtnOnselectBtnView =totalButtonArray[firstIndex];
        [totalButtonTransformArray[firstIndex] getValue:&firstBtnOnselectBtnViewTransform];
    }else{
        firstIndex=currentBtn.tag-1;
        firstBtnOnselectBtnView =totalButtonArray[firstIndex];
        [totalButtonTransformArray[firstIndex] getValue:&firstBtnOnselectBtnViewTransform];
    }
    
    //提取第二个按钮
    secondIndex =(nowSelectBtnViewPlace+btnWidth)/btnWidth;
    if ((nowSelectBtnViewPlace+btnWidth)-secondIndex*btnWidth==0) secondIndex--;
    secondBtnOnselectBtnView= totalButtonArray[secondIndex];
    [totalButtonTransformArray[secondIndex] getValue:&secondBtnOnselectBtnViewTransform];
    
    //设置比率与样式
    if (isByScroll) {
        //第一个总是需要拿右边部分，第二个总是需要拿左边部分
        firstScale=(1-(nowSelectBtnViewPlace-(int)(nowSelectBtnViewPlace/btnWidth)*btnWidth)/btnWidth)*(maxScale-minScale)+minScale;
        secondScale=((nowSelectBtnViewPlace+btnWidth)-(int)((nowSelectBtnViewPlace+btnWidth)/btnWidth)*btnWidth)/btnWidth*(maxScale-minScale)+minScale;
        
        //同一个按钮并且被点击
        if (firstIndex==secondIndex) {
            
            firstScale=maxScale;
            secondScale=maxScale;
            
            //将上次选中的恢复
            [currentBtn setTitleColor:self.normalBtnTextColor forState:UIControlStateNormal];
            //更新选中的
            [secondBtnOnselectBtnView setTitleColor:self.selectBtnTextColor forState:UIControlStateNormal];
            //保留这次的按钮
            currentBtn = firstBtnOnselectBtnView;
        }else{
            //控制最小值
            NSString *firstScaleStr=[[NSString stringWithFormat:@"%f",firstScale] substringToIndex:4];
            NSString *secondScaleStr=[[NSString stringWithFormat:@"%f",secondScale] substringToIndex:4];
            
            if ([firstScaleStr isEqualToString:@"1.00"])  firstScale=minScale;
            if ([secondScaleStr isEqualToString:@"1.00"]) secondScale=minScale;
        }
    }else{
        
        firstScale=minScale;
        secondScale=maxScale;
        
        //将上次选中的恢复
        [currentBtn setTitleColor:self.normalBtnTextColor forState:UIControlStateNormal];
        //更新选中的
        [secondBtnOnselectBtnView setTitleColor:self.selectBtnTextColor forState:UIControlStateNormal];
        //保留这次的按钮
        currentBtn = secondBtnOnselectBtnView;
    }
    
    //调节按钮一  取出所占部分
    CATransform3D firstTransform = CATransform3DMakeScale(firstScale,firstScale, minScale);
    firstBtnOnselectBtnView.layer.transform = CATransform3DConcat(firstBtnOnselectBtnViewTransform, firstTransform);
    
    //调节按钮二  取出所占部分
    CATransform3D secondTransform = CATransform3DMakeScale(secondScale,secondScale, minScale);
    secondBtnOnselectBtnView.layer.transform = CATransform3DConcat(secondBtnOnselectBtnViewTransform, secondTransform);
}

@end

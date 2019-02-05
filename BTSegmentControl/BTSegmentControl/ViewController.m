//
//  ViewController.m
//  BTSegmentControl
//
//  Created by 罗锦伟 on 15/12/6.
//  Copyright © 2015年 but819. All rights reserved.
//

#import "ViewController.h"
#import "BTSegmentControl.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController () <BTSegmentControlDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *titilArray;

@property (strong, nonatomic) BTSegmentControl *segment;

@property (weak, nonatomic) IBOutlet BTSegmentControl *ibSegment;

@property (weak, nonatomic) IBOutlet UILabel *segmentClickLabel;

@property (weak, nonatomic) IBOutlet UISlider *segmentSlider;

@property (weak, nonatomic) IBOutlet UIScrollView *segmentScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentScrollViewSubViewOneWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentScrollViewSubViewTwoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentScrollViewSubViewThreeWidth;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithRed:175.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    //title
    self.titilArray =@[@"测试1",@"测试2",@"测试3"];
    
    //segment
    self.segment =[[BTSegmentControl alloc]initWithFrame:CGRectMake(0, 200, 180, 30)AndTitleArray:self.titilArray];
    self.segment.delegate=self;
    self.segment.isUseForScrollView=YES;
    self.navigationItem.titleView=self.segment;
    
    /*
    //整体背景颜色
    segment.totalViewBackgroundColor =[UIColor yellowColor];
    //按钮默认字体颜色
    segment.normalBtnTextColor = [UIColor blueColor];
    //按钮点击字体颜色
    segment.selectBtnTextColor =[UIColor blackColor];
    //按钮点击视图背景颜色
    segment.selectBtnViewBackgroundColor=[UIColor purpleColor];
     */
    
    //slider
    self.segmentSlider.minimumValue = 0;
    self.segmentSlider.maximumValue = 1000;
    self.segmentSlider.value = 0;
    
    
    //scrollView
    self.segmentScrollView.showsHorizontalScrollIndicator = NO;
    self.segmentScrollView.showsVerticalScrollIndicator   = NO;
    self.segmentScrollView.pagingEnabled = YES;
    self.segmentScrollView.delegate      = self;
    
    self.segmentScrollViewSubViewOneWidth.constant=screenWidth;
    self.segmentScrollViewSubViewTwoWidth.constant=screenWidth;
    self.segmentScrollViewSubViewThreeWidth.constant=screenWidth;
    
    //reset ibSegment
    [self.ibSegment layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark ------------ Action ------------

- (IBAction)segmentSliderClick:(id)sender {
    
    UISlider *slide =sender;
    
    [self.segment scrollSelectBtnViewWithXPosition:slide.value MinX:slide.minimumValue AndMaxX:slide.maximumValue];
}

#pragma mark -
#pragma mark ------------ BTSegmentControlDelegate ------------

- (void)segmentControl:(BTSegmentControl *)segment didSelectedWithIndex:(NSInteger)index
{
    //更新标识字符
    [self.segmentClickLabel setText:[NSString stringWithFormat:@"点击了-测试%ld",index+1]];
    //更新scrollView
    [self.segmentScrollView setContentOffset:CGPointMake(index*screenWidth, 0) animated:YES];
}

#pragma mark -
#pragma mark ------------ ScrollViewDelegate ------------

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.segment scrollSelectBtnViewWithXPosition:scrollView.contentOffset.x MinX:0 AndMaxX:640];
}

@end

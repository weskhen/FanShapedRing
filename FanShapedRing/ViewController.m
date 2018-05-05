//
//  ViewController.m
//  FanShapedRing
//
//  Created by wujian on 2018/5/4.
//  Copyright © 2018年 wujian. All rights reserved.
//

#import "ViewController.h"
#import "XLFanShapedRingView.h"
#import "XLFanShapedAreaModel.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createXLFanShapedRingView];
}

- (void)createXLFanShapedRingView
{
    XLFanShapedRingView *ringView = [[XLFanShapedRingView alloc] initWithFrame:CGRectMake(20, 100, SCREENWIDTH-40, 300)];
    ringView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ringView];
    
    XLFanShapedAreaModel *model1 = [XLFanShapedAreaModel new];
    model1.areaValue = @"¥4";
    model1.areaColor = [UIColor redColor];
    model1.areaName = @"洗衣机消费";
    model1.textColor = [UIColor grayColor];
    model1.areaRate = 0.04;
    
    XLFanShapedAreaModel *model2 = [XLFanShapedAreaModel new];
    model2.areaValue = @"¥6";
    model2.areaColor = [UIColor yellowColor];
    model2.areaName = @"饮水机消费";
    model2.textColor = [UIColor grayColor];
    model2.areaRate = 0.06;
    
    XLFanShapedAreaModel *model3 = [XLFanShapedAreaModel new];
    model3.areaValue = @"¥60";
    model3.areaColor = [UIColor blueColor];
    model3.areaName = @"热水器消费";
    model3.textColor = [UIColor grayColor];
    model3.areaRate = 0.6;
    
    XLFanShapedAreaModel *model4 = [XLFanShapedAreaModel new];
    model4.areaValue = @"¥20";
    model4.areaColor = [UIColor greenColor];
    model4.areaName = @"水费";
    model4.textColor = [UIColor grayColor];
    model4.areaRate = 0.20;
    
    XLFanShapedAreaModel *model5 = [XLFanShapedAreaModel new];
    model5.areaValue = @"¥2";
    model5.areaColor = [UIColor blackColor];
    model5.areaName = @"上网费";
    model5.textColor = [UIColor grayColor];
    model5.areaRate = 0.02;

    XLFanShapedAreaModel *model6 = [XLFanShapedAreaModel new];
    model6.areaValue = @"¥8";
    model6.areaColor = [UIColor purpleColor];
    model6.areaName = @"电话费";
    model6.textColor = [UIColor grayColor];
    model6.areaRate = 0.08;

    [ringView showFanShapedRingViewWithModels:@[model1,model2,model3,model4,model5,model6]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  XLFanShapedAreaModel.h
//  FanShapedRing
//
//  Created by wujian on 2018/5/4.
//  Copyright © 2018年 wujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIColor,UIFont;
@interface XLFanShapedAreaModel : NSObject

/** 扇形区域值 **/
@property (nonatomic, copy) NSString *areaValue;

/** 扇形区域颜色 **/
@property (nonatomic, strong) UIColor *areaColor;

/** 扇形区域名字 **/
@property (nonatomic, copy) NSString *areaName;

/** 标注颜色 **/
@property (nonatomic, strong) UIColor *textColor;

/** 扇形区域占整个圆的比例百分制 **/
@property (nonatomic, assign) float areaRate;


/** 圆弧描述字体大小 **/
@property (nonatomic, strong) UIFont *labelFont;

@property (nonatomic, assign) CGRect touchRect;

@property (nonatomic, assign) NSInteger index;
@end

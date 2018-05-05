//
//  XLFanShapedRingView.h
//  FanShapedRing
//
//  Created by wujian on 2018/5/4.
//  Copyright © 2018年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLFanShapedAreaModel;

@protocol XLFanShapedRingViewDelegate <NSObject>

/** 点击到对应的区域 **/
- (void)fanShapedRingViewClicked:(XLFanShapedAreaModel *)model;

@end
@interface XLFanShapedRingView : UIView

@property (nonatomic, weak) id<XLFanShapedRingViewDelegate> delegate;

/** 视图左右间距 默认15 **/
- (void)setCurrentViewPadding:(CGFloat)padding;

/** 环中心点到圆心的距离 (外环和内环的平均值) 默认55 **/
- (void)setCurrentViewRingCenterDistance:(CGFloat)distance;

/** 折线x、y坐标的移动距离 默认为10**/
- (void)setCurrentViewPolyLineDisplacement:(CGFloat)displacement;

/** 打开绘制动画 默认关闭 **/
- (void)openViewDrawAnimation:(BOOL)animation;

- (void)showFanShapedRingViewWithModels:(NSArray<XLFanShapedAreaModel *> *)fanShapedAreaList;

@end

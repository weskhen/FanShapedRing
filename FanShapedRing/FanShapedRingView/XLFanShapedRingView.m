//
//  XLFanShapedRingView.m
//  FanShapedRing
//
//  Created by wujian on 2018/5/4.
//  Copyright © 2018年 wujian. All rights reserved.
//

#import "XLFanShapedRingView.h"
#import "XLFanShapedAreaModel.h"
#import "XLShapeLayer.h"

#define XLDegreeToAngle(degrees)  ((2*M_PI*degrees)-(M_PI/2)) //度数转换角度
#define XLRingCenterDistance 55 //环中心点到圆心的距离 (外环和内环的平均值)
#define XLViewPadding 15 //视图左右间距
#define XLPolyLineDisplacement 10 //折线x、y坐标的移动距离
#define XLTextLinePadding 3 //文本和线之间的距离
#define XLTextMinPaddingValue 45

#define XLArcWidth 30 //圆弧的宽度

@interface XLFanShapedRingView ()

@property (nonatomic, strong) NSArray *fanShapedAreaList;

/** 圆心 **/
@property (nonatomic, assign) CGPoint circleCenter;
/** 默认XLViewPadding **/
@property (nonatomic, assign) CGFloat viewPadding;
/** 默认XLPolyLineDisplacement **/
@property (nonatomic, assign) CGFloat polyLineDisplacement;
/** 默认XLRingCenterDistance **/
@property (nonatomic, assign) CGFloat ringCenterDistance;

/** 是否打开动画 **/
@property (nonatomic, assign) BOOL drawAnimation;
@end

@implementation XLFanShapedRingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.circleCenter = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        self.viewPadding = XLViewPadding;
        self.polyLineDisplacement = XLPolyLineDisplacement;
        self.ringCenterDistance = XLRingCenterDistance;
    }
    return self;
}

#pragma mark - publicMethod
- (void)setCurrentViewPadding:(CGFloat)padding
{
    _viewPadding = padding;
}

- (void)setCurrentViewRingCenterDistance:(CGFloat)distance
{
    _ringCenterDistance = distance;
}

- (void)setCurrentViewPolyLineDisplacement:(CGFloat)displacement
{
    _polyLineDisplacement = displacement;
}

- (void)openViewDrawAnimation:(BOOL)animation
{
    self.drawAnimation = animation;
}

- (void)showFanShapedRingViewWithModels:(NSArray<XLFanShapedAreaModel *> *)fanShapedAreaList
{
    self.fanShapedAreaList = fanShapedAreaList;
    [self setNeedsDisplay];
}

#pragma mark - privateMethod
- (void)drawRect:(CGRect)rect
{
    if (self.fanShapedAreaList.count == 0) {
        return;
    }
    
    float lastAngle = 0; //从0起点开始
    
    CGPoint lastCenterPoint = CGPointZero;
    for (int i = 0; i < self.fanShapedAreaList.count; i++) {
        XLFanShapedAreaModel *model = [self.fanShapedAreaList objectAtIndex:i];
        model.index = i;
        
        float startAngle = lastAngle;
        float endAngle = startAngle+model.areaRate;
        
        XLShapeLayer * progressLayer = [XLShapeLayer new];
        progressLayer.index = i;
        UIBezierPath * progressPath = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:self.ringCenterDistance startAngle:XLDegreeToAngle(startAngle) endAngle:XLDegreeToAngle(endAngle) clockwise:YES];
        progressLayer.path = CGPathCreateCopyByStrokingPath(progressPath.CGPath, &CGAffineTransformIdentity, XLArcWidth, kCGLineCapButt, kCGLineJoinBevel, 0);
        progressLayer.fillColor = model.areaColor.CGColor;
//        progressLayer.strokeColor = model.areaColor.CGColor;
        [self.layer addSublayer:progressLayer];
        lastAngle = endAngle;
        
        //画线 弧度的中心角度
        CGFloat radianCenterCoordinate = (XLDegreeToAngle(startAngle) + XLDegreeToAngle(endAngle)) / 2.0;
        CGPoint centerCoordinate = CGPointMake(self.circleCenter.x+(self.ringCenterDistance+XLArcWidth/2.0)*cos(radianCenterCoordinate), self.circleCenter.y+(self.ringCenterDistance+XLArcWidth/2.0)*sin(radianCenterCoordinate));
        
        CGPoint straightLinePoint = CGPointZero;
        CGPoint endPoint = CGPointZero;
        
        BOOL willPolyLine = NO;
        if (CGPointEqualToPoint(lastCenterPoint, CGPointZero)) {
            //第一个点默认折线
            willPolyLine = YES;
            straightLinePoint = CGPointMake((centerCoordinate.x < self.circleCenter.x)?(centerCoordinate.x-self.polyLineDisplacement):(centerCoordinate.x+self.polyLineDisplacement), (centerCoordinate.y < self.circleCenter.y)?(centerCoordinate.y-self.polyLineDisplacement):(centerCoordinate.y+self.polyLineDisplacement));
        }
        else
        {
            if ((centerCoordinate.x > self.circleCenter.x && lastCenterPoint.x > self.circleCenter.x)) {
                //和前一个点位于圆心同一侧(右侧)
                CGFloat yMin = centerCoordinate.y - lastCenterPoint.y;
                if (yMin < XLTextMinPaddingValue) {
                    //折线幅度加大 用外切线来实现
                    float xPadding = fabs((self.ringCenterDistance+XLArcWidth/2.0 - (self.circleCenter.y-lastCenterPoint.y-XLTextMinPaddingValue)*cos(radianCenterCoordinate))/sin(radianCenterCoordinate));
                    straightLinePoint = CGPointMake(centerCoordinate.x+xPadding + XLArcWidth/2.0, lastCenterPoint.y+XLTextMinPaddingValue);
                }
            }
            else if (centerCoordinate.x < self.circleCenter.x && lastCenterPoint.x < self.circleCenter.x)
            {
                //和前一个点位于圆心同一侧(左侧侧)
                CGFloat yMin = lastCenterPoint.y - centerCoordinate.y;
                if (yMin < XLTextMinPaddingValue) {
                    //折线幅度加大
                    float xPadding = fabs((self.ringCenterDistance+XLArcWidth/2.0 - (lastCenterPoint.y-self.circleCenter.y-XLTextMinPaddingValue)*cos(radianCenterCoordinate))/sin(radianCenterCoordinate));
                    straightLinePoint = CGPointMake(centerCoordinate.x-xPadding-XLArcWidth/2.0, lastCenterPoint.y-XLTextMinPaddingValue);
                }
            }
            else
            {
                //没有在同一侧不会有文本交集 直接用直线 不需要设置
            }
        }
        
        if (CGPointEqualToPoint(straightLinePoint, CGPointZero)) {
            //直线
            endPoint = CGPointMake((centerCoordinate.x < self.circleCenter.x)?(self.viewPadding):(CGRectGetWidth(self.bounds)-self.viewPadding), centerCoordinate.y);
            lastCenterPoint = centerCoordinate;
        }
        else{
            //折线
            endPoint = CGPointMake((centerCoordinate.x < self.circleCenter.x)?(self.viewPadding):(CGRectGetWidth(self.bounds)-self.viewPadding), straightLinePoint.y);
            lastCenterPoint = straightLinePoint;
        }

        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:centerCoordinate];
        if (!CGPointEqualToPoint(straightLinePoint, CGPointZero)) {
            [path addLineToPoint:straightLinePoint];
        }
        [path addLineToPoint:endPoint];
        CAShapeLayer *lineLayer = [CAShapeLayer new];
        lineLayer.path = path.CGPath;
        lineLayer.fillColor = nil;
        lineLayer.opacity = 1.0;
        lineLayer.strokeColor = model.areaColor.CGColor;
        lineLayer.lineWidth = 1.0f;
        [self.layer addSublayer:lineLayer];

        //写文本
        NSDictionary *attr = @{NSFontAttributeName:model.labelFont,NSForegroundColorAttributeName:model.textColor};
        CGRect nameRect = [model.areaName boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
        CGRect valueRect = [model.areaValue boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
        nameRect.origin.x = (centerCoordinate.x < self.circleCenter.x)?(self.viewPadding):(CGRectGetWidth(self.bounds)-self.viewPadding-nameRect.size.width);
        nameRect.origin.y = endPoint.y+XLTextLinePadding;
        
        valueRect.origin.x = (centerCoordinate.x < self.circleCenter.x)?(self.viewPadding):(CGRectGetWidth(self.bounds)-self.viewPadding-valueRect.size.width);
        valueRect.origin.y = endPoint.y-XLTextLinePadding-valueRect.size.height;
        
        [model.areaName drawInRect:nameRect withAttributes:attr];
        [model.areaValue drawInRect:valueRect withAttributes:attr];
        
        //增大触摸响应区域 上下左右5px
        model.touchRect = CGRectMake((centerCoordinate.x < self.circleCenter.x)?(valueRect.origin.x-5):(MIN(nameRect.origin.x, valueRect.origin.x)-5), CGRectGetMinY(valueRect)-5, MAX(CGRectGetWidth(nameRect), CGRectGetWidth(valueRect))+10, CGRectGetMaxY(nameRect)-CGRectGetMinY(valueRect)+10);
    }
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    //得到触摸点
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //调用上面确定selectIndex的方法
    NSInteger selectIndex = [self getCurrentSelectedOnTouch:point];
    if (selectIndex != -1) {
        NSLog(@"被点击的部分------%ld",(long)selectIndex);
    }
}

- (NSInteger)getCurrentSelectedOnTouch:(CGPoint)point {
    //初始化selectIndex
    __block NSInteger selectIndex = -1;
    //遍历饼图中的子layer
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[XLShapeLayer class]]) {
            XLShapeLayer *shapeLayer = (XLShapeLayer *)obj;
            CGPathRef path = [shapeLayer path];
            //CGPathContainsPoint: 如果点包含在路径中,则返回true 坐标重置
            if (CGPathContainsPoint(path, &CGAffineTransformIdentity, point, 0)) {
                selectIndex = shapeLayer.index;
                *stop = YES;
            }
        }
    }];
    
    if (selectIndex == -1) {
        //没有点击到相应的饼图 继续查询文本描述区域
        for (XLFanShapedAreaModel *model in self.fanShapedAreaList) {
            if (CGRectContainsPoint(model.touchRect, point)) {
                selectIndex = model.index;
                break;
            }
        }
    }
    return selectIndex;
}

@end

//
//  XLFanShapedAreaModel.m
//  FanShapedRing
//
//  Created by wujian on 2018/5/4.
//  Copyright © 2018年 wujian. All rights reserved.
//

#import "XLFanShapedAreaModel.h"
#import <UIKit/UIKit.h>

@implementation XLFanShapedAreaModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //默认字体 颜色
        _labelFont = [UIFont systemFontOfSize:10];
        _textColor = [UIColor grayColor];
    }
    return self;
}
@end

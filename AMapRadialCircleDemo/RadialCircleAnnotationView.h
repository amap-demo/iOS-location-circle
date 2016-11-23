//
//  RadialCircleAnnotationView.h
//  AMapRadialCircleDemo
//
//  Created by liubo on 11/23/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface RadialCircleAnnotationView : MAAnnotationView

@property (nonatomic, assign) NSInteger pulseCount;
@property (nonatomic, assign) double animationDuration;
@property (nonatomic, assign) double baseDiameter;
@property (nonatomic, assign) double scale;

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;

- (void)startPulseAnimation;
- (void)stopPulseAnimation;

@end

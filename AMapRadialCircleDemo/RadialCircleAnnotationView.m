//
//  RadialCircleAnnotationView.m
//  AMapRadialCircleDemo
//
//  Created by liubo on 11/23/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

#import "RadialCircleAnnotationView.h"
#import <QuartzCore/QuartzCore.h>

@interface RadialCircleAnnotationView ()

@property (nonatomic, strong) CALayer *fixedLayer;
@property (nonatomic, strong) NSMutableArray *pulseLayers;

@end

@implementation RadialCircleAnnotationView

#pragma mark - Lift Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self buildRadialCircle];
    }
    return self;
}

- (void)buildRadialCircle
{
    self.pulseLayers = [[NSMutableArray alloc] init];
    
    //Default Value
    self.pulseCount = 4;
    self.animationDuration = 8.0;
    self.baseDiameter = 8.0;
    self.scale = 30.0;
    self.fillColor = [UIColor colorWithRed:24.f/255.f green:137.f/255.f blue:234.f/255.f alpha:1.0];
    self.strokeColor = [UIColor colorWithRed:35.f/255.f green:35.f/255.f blue:255.f/255.f alpha:1.0];
    
    //fixedLayer
    double fixedLayerDiameter = 20;
    self.layer.bounds = CGRectMake(0, 0, fixedLayerDiameter, fixedLayerDiameter);
    
    self.fixedLayer = [CALayer layer];
    self.fixedLayer.bounds = self.layer.bounds;
    self.fixedLayer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    self.fixedLayer.cornerRadius = fixedLayerDiameter / 2.0;
    self.fixedLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.fixedLayer.borderColor = [UIColor whiteColor].CGColor;
    self.fixedLayer.borderWidth = 4;
    [self.layer addSublayer:self.fixedLayer];
    
    [self startPulseAnimation];
}

#pragma mark - Interface

- (void)stopPulseAnimation
{
    for (CALayer *aLayer in self.pulseLayers)
    {
        [aLayer removeAllAnimations];
        [aLayer removeFromSuperlayer];
    }
    
    [self.pulseLayers removeAllObjects];
}

- (void)startPulseAnimation
{
    if ([self.pulseLayers count] > 0)
    {
        [self stopPulseAnimation];
    }
    
    CFTimeInterval currentMediaTime = CACurrentMediaTime();
    CFTimeInterval timeIntercal = self.animationDuration / self.pulseCount;
    
    for (int i = 0; i < self.pulseCount; i++)
    {
        CALayer *aLayer = [self buildPulseLayerWithBuginTime:(currentMediaTime + timeIntercal * i)];
        
        [self.pulseLayers addObject:aLayer];
        [self.layer addSublayer:aLayer];
    }
}

#pragma mark - Utility

- (CALayer *)buildPulseLayerWithBuginTime:(CFTimeInterval)beginTime
{
    CALayer *aLayer = [CALayer layer];
    
    aLayer.bounds = CGRectMake(0, 0, self.baseDiameter, self.baseDiameter);
    aLayer.position = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
    aLayer.cornerRadius = self.baseDiameter / 2.0;
    aLayer.backgroundColor = self.fillColor.CGColor;
    aLayer.borderColor = self.strokeColor.CGColor;
    aLayer.borderWidth = 2;
    aLayer.opacity = 0;
    aLayer.zPosition = -100;
    
    CAAnimation *pulseAnimation = [self buildPulseAnimationWithDiameter:self.baseDiameter
                                                                  scale:self.scale
                                                               duration:self.animationDuration
                                                              beginTime:beginTime];
    [aLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
    
    return aLayer;
}

- (CAAnimation *)buildPulseAnimationWithDiameter:(CGFloat)diameter scale:(float)scale duration:(float)duration beginTime:(CFTimeInterval)beginTime
{
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *aniFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    aniFade.fromValue = @(0.65);
    aniFade.toValue = @(0.0);
    
    CABasicAnimation *aniScale = [CABasicAnimation animationWithKeyPath:@"bounds"];
    aniScale.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, diameter, diameter)];
    aniScale.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, diameter * scale, diameter * scale)];
    
    CABasicAnimation *aniCorner = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    aniCorner.fromValue = @(diameter / 2.0);
    aniCorner.toValue = @(diameter * scale / 2.0);
    
    aniGroup.animations = @[aniFade, aniScale, aniCorner];
    aniGroup.removedOnCompletion = NO;
    aniGroup.duration = duration;
    aniGroup.repeatCount = HUGE_VALF;
    aniGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    aniGroup.beginTime = beginTime;
    
    return aniGroup;
}

@end

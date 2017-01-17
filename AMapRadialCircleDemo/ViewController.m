//
//  ViewController.m
//  AMapRadialCircleDemo
//
//  Created by liubo on 11/23/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "RadialCircleAnnotationView.h"

#define kAPIKey @"674acab75f00ff20ba1b1d21399be723"

@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAPointAnnotation *annotation;

@end

@implementation ViewController

#pragma mark - MapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        RadialCircleAnnotationView *annotationView = (RadialCircleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[RadialCircleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            annotationView.canShowCallout = YES;
            
            //脉冲圈个数
            annotationView.pulseCount = 4;
            //单个脉冲圈动画时长
            annotationView.animationDuration = 8.0;
            //单个脉冲圈起始直径
            annotationView.baseDiameter = 8.0;
            //单个脉冲圈缩放比例
            annotationView.scale = 30.0;
            //单个脉冲圈fillColor
            annotationView.fillColor = [UIColor colorWithRed:24.f/255.f green:137.f/255.f blue:234.f/255.f alpha:1.0];
            //单个脉冲圈strokeColor
            annotationView.strokeColor = [UIColor colorWithRed:35.f/255.f green:35.f/255.f blue:255.f/255.f alpha:1.0];
            
            //更改设置后重新开始动画
            [annotationView startPulseAnimation];
        }
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Utility

- (void)addOneAnnotation
{
    self.annotation = [[MAPointAnnotation alloc] init];
    self.annotation.coordinate = self.mapView.centerCoordinate;
    self.annotation.title = @"RadialCircleAnnotation";
    
    [self.mapView addAnnotation:self.annotation];
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)initLockAnnotationButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"LockToScreen" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor darkGrayColor]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    button.frame = CGRectMake(10, 80, 120, 40);
    [button addTarget:self action:@selector(lockBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)lockBtnAction
{
    self.annotation.lockedScreenPoint = [self.mapView convertCoordinate:self.annotation.coordinate toPointToView:self.view];
    self.annotation.lockedToScreen = !self.annotation.lockedToScreen;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = kAPIKey;
    
    [self initMapView];
    
    [self initLockAnnotationButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addOneAnnotation];
}

@end

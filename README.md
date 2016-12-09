本工程为基于高德地图iOS 2D地图SDK进行封装，实现了脉冲圈向外缩放的动画效果。
## 前述 ##
- [高德官网申请Key](http://lbs.amap.com/dev/#/).
- 阅读[开发指南](http://lbs.amap.com/api/ios-sdk/summary/).
- 工程基于iOS 2D地图SDK实现.

## 功能描述 ##
基于2D地图SDK进行封装，实现了脉冲圈向外缩放的动画效果，可自定义圆圈个数，动画时长，缩放比例，圆圈颜色等。

## 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| RadialCircleAnnotationView | --- | 继承自MAAnnotationView，实现脉冲圈向外缩放的动画效果 | --- |
| MAMapView | - (void)addAnnotation:(id <MAAnnotation>)annotation; | 向地图窗口添加标注 | v4.0.0 |

## 核心难点 ##

`Objective-C`

```
/* 增加RadialCircleAnnotationView. */
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
```
`Swift`

```
/* 增加RadialCircleAnnotationView. */
func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAPointAnnotation {
            let pointReuseIndetifier = "pointReuseIdentifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? RadialCircleAnnotationView
            
            if annotationView == nil {
                annotationView = RadialCircleAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.canShowCallout  = true
            
            //脉冲圈个数
            annotationView?.pulseCount = 4
            //单个脉冲圈动画时长
            annotationView?.animationDuration = 8.0
            //单个脉冲圈起始直径
            annotationView?.baseDiameter = 8.0
            //单个脉冲圈缩放比例
            annotationView?.scale = 30.0
            //单个脉冲圈fillColor
            annotationView?.fillColor = UIColor(red: 24.0/255.0, green: 137.0/255.0, blue: 234.0/255.0, alpha: 1.0)
            //单个脉冲圈strokeColor
            annotationView?.strokeColor = UIColor(red: 35.0/255.0, green: 35.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
            //更改设置后重新开始动画
            annotationView?.startPulseAnimation()
            
            return annotationView
        }
        
        return nil
    }
```

## 截图效果 ##

![ScreenShot](https://raw.githubusercontent.com/amap-demo/iOS-location-circle/master/IMG_00.PNG)


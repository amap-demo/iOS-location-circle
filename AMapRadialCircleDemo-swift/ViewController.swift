//
//  ViewController.swift
//  AMapRadialCircleDemo-swift
//
//  Created by liubo on 12/6/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

import UIKit

let APIKey = "674acab75f00ff20ba1b1d21399be723"

class ViewController: UIViewController, MAMapViewDelegate {
    
    var mapView: MAMapView!
    var annotaion: MAPointAnnotation!
    
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

    //MARK: - Utility
    
    func addOneAnnotation() {
        annotaion = MAPointAnnotation()
        
        annotaion.coordinate = mapView.centerCoordinate
        annotaion.title = "RadialCircleAnnotation"
        
        mapView.addAnnotation(annotaion)
    }

    //MARK: - Initialization
    
    func initMapView() {
        mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func initLockAnnotationButton() {
        let button = UIButton(type: .custom)
        button.setTitle("LockToScreen", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.red, for: .normal)
        
        button.frame = CGRect(x: 10, y: 80, width: 120, height: 40)
        button.addTarget(self, action: #selector(self.lockBtnAction), for: .touchUpInside)
        
        view.addSubview(button);
    }
    
    func lockBtnAction() {
        annotaion.lockedScreenPoint = mapView.convert(annotaion.coordinate, toPointTo: view)
        annotaion.isLockedToScreen = !annotaion.isLockedToScreen
    }
    
    //MARK: - Life Cyele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AMapServices.shared().apiKey = APIKey
        
        initMapView()
        
        initLockAnnotationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addOneAnnotation()
    }

}


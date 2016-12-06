//
//  RadialCircleAnnotationView.swift
//  AMapRadialCircleDemo
//
//  Created by liubo on 12/6/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

import Foundation

class RadialCircleAnnotationView: MAAnnotationView {
    
    var pulseCount = 4
    var animationDuration = 8.0
    var baseDiameter = 8.0
    var scale = 30.0
    var fillColor = UIColor(red: 24.0/255.0, green: 137.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    var strokeColor = UIColor(red: 35.0/255.0, green: 35.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    var fixedLayer = CALayer()
    var pulseLayers = Array<CALayer>()
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        buildRadialCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func buildRadialCircle() {
        let fixedLayerDiameter = 20.0
        layer.bounds = CGRect(x: 0, y: 0, width: fixedLayerDiameter, height: fixedLayerDiameter)
        
        fixedLayer.bounds = layer.bounds
        fixedLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        fixedLayer.cornerRadius = CGFloat(fixedLayerDiameter / 2.0)
        fixedLayer.backgroundColor = UIColor.blue.cgColor
        fixedLayer.borderColor = UIColor.white.cgColor
        fixedLayer.borderWidth = 4.0
        layer.addSublayer(fixedLayer)
        
        startPulseAnimation()
    }
    
    func stopPulseAnimation() {
        for aLayer in pulseLayers {
            aLayer.removeAllAnimations()
            aLayer.removeFromSuperlayer()
        }
        
        pulseLayers.removeAll()
    }
    
    func startPulseAnimation() {
        if pulseLayers.count > 0 {
            stopPulseAnimation()
        }
        
        let currentMediaTime = CACurrentMediaTime()
        let timeInterval = Double(animationDuration / Double(pulseCount))
        
        for i in 0...pulseCount {
            let aLayer = buildPulseLayer(beginTime: currentMediaTime + timeInterval * Double(i))
            
            pulseLayers.append(aLayer)
            layer.addSublayer(aLayer)
        }
    }
    
    func buildPulseLayer(beginTime: CFTimeInterval) -> CALayer {
        let aLayer = CALayer()
        
        aLayer.bounds = CGRect(x: 0, y: 0, width: baseDiameter, height: baseDiameter)
        aLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        aLayer.cornerRadius = CGFloat(baseDiameter / 2.0)
        aLayer.backgroundColor = fillColor.cgColor
        aLayer.borderColor = strokeColor.cgColor
        aLayer.borderWidth = 2
        aLayer.opacity = 0
        aLayer.zPosition = -100
        
        let pulseAnimation = buildPulseAnimation(diameter: baseDiameter, scale: scale, duration: animationDuration, beginTime: beginTime)
        aLayer.add(pulseAnimation, forKey: "pulseAnimation")
        
        return aLayer
    }
    
    func buildPulseAnimation(diameter: Double, scale: Double, duration: TimeInterval, beginTime: CFTimeInterval) -> CAAnimation {
        let aniGroup = CAAnimationGroup()
        
        let aniFade = CABasicAnimation(keyPath: "opacity")
        aniFade.fromValue = (0.65)
        aniFade.toValue = (0.0)
        
        let aniScale = CABasicAnimation(keyPath: "bounds")
        aniScale.fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        aniScale.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: diameter*scale, height: diameter*scale))
        
        let aniCorner = CABasicAnimation(keyPath: "cornerRadius")
        aniCorner.fromValue = (diameter / 2.0)
        aniCorner.toValue = (diameter * scale / 2.0)
        
        aniGroup.animations = [aniFade, aniScale, aniCorner]
        aniGroup.isRemovedOnCompletion = false
        aniGroup.duration = duration
        aniGroup.repeatCount = Float.infinity
        aniGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        aniGroup.beginTime = beginTime
        
        return aniGroup;
    }
}

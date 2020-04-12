//
//  SettingsSliderTrack.swift
//  Clocks
//
//  Created by Brian Cooke on 4/11/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//

import UIKit

class SettingsSliderTrack: UIView {
    
    let trackSize = 60
    let lineWidth = CGFloat(1.5)
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation. */
    override func draw(_ rect: CGRect) {
        let trackRadius = CGFloat(trackSize / 2)
        
        if let subLayers = layer.sublayers {
            for aLayer in subLayers {
                aLayer.removeFromSuperlayer()
            }
        }
        
        let minY = getMinY(rect: rect)
        let maxY = getMaxY(rect: rect)
        let minX = rect.minX + lineWidth
        let maxX = rect.maxX - lineWidth
        
        UIColor.white.setStroke()
        
        strokeLine(startPoint: CGPoint(x: rect.midX, y: minY), endPoint: CGPoint(x: rect.midX, y: maxY))
        strokeLine(startPoint: CGPoint(x: minX, y: minY), endPoint: CGPoint(x: minX, y: maxY))
        strokeLine(startPoint: CGPoint(x: maxX, y: minY), endPoint: CGPoint(x: maxX, y: maxY))
        
        var path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.maxY - trackRadius - lineWidth), radius: trackRadius - lineWidth, startAngle: 180.degreesToRadians, endAngle: 0.degreesToRadians, clockwise: false)
        path.lineWidth = lineWidth
        path.stroke()
        
        path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.minY + trackRadius + lineWidth), radius: trackRadius - lineWidth, startAngle: 180.degreesToRadians, endAngle: 0.degreesToRadians, clockwise: true)
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    var trackRadius: CGFloat { return CGFloat(trackSize / 2) }
    
    func getMinY(rect : CGRect) -> CGFloat {
        return rect.minY + trackRadius + lineWidth
    }
    
    func getMaxY(rect: CGRect) -> CGFloat {
        return rect.maxY - trackRadius - lineWidth
    }
    
    func strokeLine(startPoint : CGPoint, endPoint : CGPoint)
    {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    func onSwiped() -> Void {
        
        let path = UIBezierPath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = lineWidth
        
        path.move(to: CGPoint(x: frame.midX, y: getMaxY(rect: frame)))
        path.lineWidth = lineWidth
        path.addLine(to: CGPoint(x: frame.midX, y: getMinY(rect: frame)))
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        //setNeedsDisplay()
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

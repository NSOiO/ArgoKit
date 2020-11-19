//
//  ArgoKitCornerManagerTool.swift
//  ArgoKit
//
//  Created by Bruce on 2020/11/18.
//

import Foundation
public struct ArgoKitRectCorner{
    var topLeft:CGFloat
    var topRight:CGFloat
    var bottomLeft:CGFloat
    var bottomRight:CGFloat
}
struct ArgoKitCornerRadius{
    var topLeft:CGFloat = 0
    var topRight:CGFloat = 0
    var bottomLeft:CGFloat = 0
    var bottomRight:CGFloat = 0
}

class ArgoKitCornerManagerTool {
    
    class func multiRadius(multiRadius:ArgoKitCornerRadius,corner:UIRectCorner,cornerRadius:CGFloat)->ArgoKitCornerRadius{
        var radius:ArgoKitCornerRadius = multiRadius
        if corner == UIRectCorner.allCorners{
            if (radius.topLeft != cornerRadius || radius.topRight != cornerRadius || radius.bottomLeft != cornerRadius || radius.bottomRight != cornerRadius) {
                radius.topLeft = cornerRadius;
                radius.topRight = cornerRadius;
                radius.bottomLeft = cornerRadius;
                radius.bottomRight = cornerRadius;
            }
        }
        if corner.contains(UIRectCorner.topLeft) {
            if radius.topLeft != cornerRadius {
                radius.topLeft = cornerRadius
            }
        }
        if corner.contains(UIRectCorner.topRight){
            if radius.topRight != cornerRadius {
                radius.topRight = cornerRadius
            }
        }
        if corner.contains(UIRectCorner.bottomLeft) {
            if radius.bottomLeft != cornerRadius {
                radius.bottomLeft = cornerRadius;
            }
        }
        if corner.contains(UIRectCorner.bottomRight){
            if radius.bottomRight != cornerRadius{
                radius.bottomRight = cornerRadius
            }
        }
        return radius;
        
    }
    
    class func bezierPath(frame:CGRect,multiRadius:ArgoKitCornerRadius) -> UIBezierPath {
        let width:CGFloat = frame.size.width
        let height:CGFloat = frame.size.height
        let minRadius = CGFloat.minimum(width * 0.5, height * 0.5)
        var radius:CGFloat = multiRadius.topLeft
        radius = CGFloat.maximum(CGFloat.minimum(minRadius, radius), 0)
        
        let path:UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: height/2.0))
        if radius > 0 {
            path.addLine(to: CGPoint(x: 0.0, y: radius))
            path.addArc(withCenter: CGPoint(x:radius, y:radius), radius: radius, startAngle: -CGFloat.pi, endAngle: -(CGFloat.pi/2), clockwise: true)
        }else{
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
        path.addLine(to: CGPoint(x:width/2.0, y:0))
        
        
        radius = multiRadius.topRight
        radius = CGFloat.maximum(CGFloat.minimum(minRadius, radius), 0)
        if radius > 0 {
            path.addLine(to: CGPoint(x: width - radius, y: 0))
            path.addArc(withCenter: CGPoint(x:width - radius, y:radius), radius: radius, startAngle: -(CGFloat.pi/2), endAngle: 0, clockwise: true)
        }else{
            path.addLine(to: CGPoint(x:width, y: 0))
        }
        path.addLine(to: CGPoint(x:width, y:height/2.0))
        
        
        radius = multiRadius.bottomRight
        radius = CGFloat.maximum(CGFloat.minimum(minRadius, radius), 0)
        if radius > 0 {
            path.addLine(to: CGPoint(x: width, y: height - radius))
            path.addArc(withCenter: CGPoint(x:width - radius, y:height - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        }else{
            path.addLine(to: CGPoint(x:width, y: height))
        }
        path.addLine(to: CGPoint(x:width/2.0, y:height))
        
        radius = multiRadius.bottomLeft
        radius = CGFloat.maximum(CGFloat.minimum(minRadius, radius), 0)
        if radius > 0 {
            path.addLine(to: CGPoint(x: radius, y: height))
            path.addArc(withCenter: CGPoint(x:radius, y:height - radius), radius: radius, startAngle:CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        }else{
            path.addLine(to: CGPoint(x:0, y: height))
        }
        path.addLine(to: CGPoint(x:0, y:height/2.0))
        
       return path
    }
    
    
}

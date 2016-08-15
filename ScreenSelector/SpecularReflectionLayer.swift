//
//  SpecularReflectionLayer.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/26.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit

final public class SpecularReflectionLayer: CALayer {

    init(sourceView: UIView, xAngle: Double = M_PI) {
        super.init()
        bounds = sourceView.bounds
        commonInit(sourceView: sourceView, xAngle: xAngle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(sourceView view: UIView, xAngle: Double) {
        let image         = generateImageOfView(sourceView: view)
        contents          = image.CGImage
        opacity           = 1.0
        anchorPoint       = CGPoint(x: 0.5, y: 1.0)
        position          = CGPoint(x: bounds.width * 0.5, y: bounds.height + 20)
        actions           = ["transform" : NSNull()]
        var perspective   = CATransform3DIdentity
        perspective.m34   = 1 / bounds.height * 0.25
        transform         = CATransform3DConcat(CATransform3DMakeRotation(CGFloat(xAngle), 1, 0, 0), perspective)
        let gradientLayer = generateGradientLayer()
        mask              = gradientLayer
        gradientLayer.anchorPoint = anchorPoint
        gradientLayer.position    = position
    }
    
    private func generateGradientLayer() -> CAGradientLayer {
        let gradientLayer    = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor, UIColor.clearColor().CGColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 0.75)
        gradientLayer.bounds     = bounds
        return gradientLayer
    }
    
    private func generateImageOfView(sourceView view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        #if TARGET_INTERFACE_BUILDER
            if let context = UIGraphicsGetCurrentContext() {
                view.layer.renderInContext(context)
            }
        #else
            view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        #endif
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

//
//  ScreenPreviewView.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/22.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit

public protocol ScreenPreviewViewProtocol: class {
    var titleLabel: UILabel! { get set }
    var imageView: UIImageView! { get set }
}

public class ScreenPreviewView: UIView, ScreenPreviewViewProtocol {
    
    public var titleLabel: UILabel!    = UILabel()
    public var imageView: UIImageView! = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let imageAreaRatio: CGFloat   = 0.9
        var titleLabelFrame           = titleLabel.frame
        titleLabelFrame.origin.y      = 0
        titleLabelFrame.size.height   = bounds.height * (1-imageAreaRatio)
        titleLabelFrame.size.width    = bounds.width * imageAreaRatio
        titleLabel.frame              = titleLabelFrame
        titleLabel.center             = CGPoint(x: bounds.midX, y: titleLabel.center.y)
        titleLabel.textAlignment      = .Center
        var imageViewFrame            = imageView.frame
        imageViewFrame.size.height    = bounds.height * imageAreaRatio
        imageViewFrame.size.width     = bounds.width  * imageAreaRatio
        imageViewFrame.origin.y       = titleLabel.frame.maxY
        imageView.frame               = imageViewFrame
        imageView.center              = CGPoint(x: bounds.width * 0.5, y: imageView.center.y)
        imageView.contentMode         = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
}

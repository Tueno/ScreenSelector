//
//  DummyScreenGenerator.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/26.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit

final class DummyScreenGenerator {
    
    class func generateViews() -> [ScreenSelectorPreviewable] {
        var views = [ScreenSelectorPreviewable]()
        for _ in 0.stride(to: 5, by: 1) {
            let view = DummyView()
            views.append(view)
        }
        return views
    }
    
}

final class DummyScreenDataSource: ScreenSelectorViewDataSource {
    
    let dummyScreeens = DummyScreenGenerator.generateViews()
    func previewViewForScreenAtIndex(index: Int) -> ScreenPreviewViewProtocol {
        let size                   = CGSize(width: UIScreen.mainScreen().bounds.width * 0.6, height: UIScreen.mainScreen().bounds.height * 0.6)
        let screenView             = ScreenPreviewView(frame: CGRect(origin: CGPoint.zero, size: size))
        let previewable            = dummyScreeens[index]
        let previewImage: UIImage? = previewable.thumbnailImage
        let titleText: String?     = "Title"
        screenView.titleLabel.text = titleText
        screenView.imageView.image = previewImage
        return screenView
    }
    
    func numberOfScreens() -> Int {
        return dummyScreeens.count
    }
    
}

final class DummyView: UIView, ScreenSelectorPreviewable {
    
    @IBOutlet weak var backgroundImageView: UIImageView?
    var thumbnailImage: UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0)
            if let context = UIGraphicsGetCurrentContext() {
                let path       = UIBezierPath(rect: UIScreen.mainScreen().bounds)
                path.lineWidth = 4
                path.stroke()
                CGContextAddPath(context, path.CGPath)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image
            } else {
                UIGraphicsEndImageContext()
                return nil
            }
        }
    }
    var title: String? = "Title"
    
}

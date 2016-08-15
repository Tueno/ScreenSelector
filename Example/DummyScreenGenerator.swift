//
//  DummyScreenGenerator.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/26.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit
import ScreenSelector

final class DummyScreenGenerator {
    
    class func generateViewControllers() -> [ScreenSelectorPreviewable] {
        var viewControllers = [ScreenSelectorPreviewable]()
        for i in 0.stride(to: 5, by: 1) {
            let vc             = UIStoryboard.init(name: "ContentViewController", bundle: nil).instantiateInitialViewController() as? ContentViewController
            vc?.view.tag       = i
            vc?.textLabel.text = "\(i)"
            vc?.title          = "Title \(i)"
            if let v = vc as? ScreenSelectorPreviewable {
                viewControllers.append(v)
            }
        }
        return viewControllers
    }
    
}

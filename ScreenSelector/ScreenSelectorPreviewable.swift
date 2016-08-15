//
//  ScreenSelectorPreviewable.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/22.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit

public protocol ScreenSelectorPreviewable: class {
    var thumbnailImage: UIImage? { get }
    var backgroundImageView: UIImageView? { get }
}

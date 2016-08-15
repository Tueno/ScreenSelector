//
//  ReversibleAnimatedTransitioning.swift
//  Oder
//
//  Created by Tomonori Ueno on 2016/05/10.
//  Copyright © 2016年 Showcase Gig Inc. All rights reserved.
//

import UIKit

public protocol ReversibleAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    var isReverse: Bool { get set }
    init()
    
}

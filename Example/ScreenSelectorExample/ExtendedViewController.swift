//
//  ExtendedViewController.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/20.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit
import ScreenSelector

final class ExtendedViewController: ScreenSelectorViewController {
    
    @IBOutlet weak var sampleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenSelectorView.previewReflectionEnabled = true
        self.previewableScreens = DummyScreenGenerator.generateViewControllers()
        self.screenSelectorView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

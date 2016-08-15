//
//  ContentViewController.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/22.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit
import ScreenSelector

final class ContentViewController: UIViewController, ScreenSelectorPreviewable {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView?

    var thumbnailImage: UIImage? {
        get {
            return UIImage(named: "example_bg.jpg")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecog  = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        view.addGestureRecognizer(tapRecog)
    }
    
    func tapped(tapRecog: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

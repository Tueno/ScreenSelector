//
//  ViewController.swift
//  ScreenSelectorExample
//
//  Created by Tomonori on 2016/08/15.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit
import ScreenSelector

final class ViewController: UIViewController, ScreenSelectorViewDelegate, ScreenSelectorViewDataSource, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var screenSelectorView: ScreenSelectorView!
    private var previewableScreens: [ScreenSelectorPreviewable] = []

    weak var transitionFromPreviewImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        previewableScreens            = DummyScreenGenerator.generateViewControllers()
        screenSelectorView.delegate   = self
        screenSelectorView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - ScreenSelectorView Delegate
    
    func screenSelectorViewDidTapScreenAtIndex(index: Int, previewView: ScreenPreviewViewProtocol) {
        transitionFromPreviewImageView = previewView.imageView
        if let viewController = previewableScreens[index] as? UIViewController {
            viewController.transitioningDelegate = self
            presentViewController(viewController, animated: true) {
                // Move selected preview to center of screen.
                self.screenSelectorView.scrollToIndex(index, animated: false)
            }
        }
    }
    
    // MARK: - ScreenSelectorView DataSource
    
    func numberOfScreens() -> Int {
        return previewableScreens.count
    }
    
    func previewViewForScreenAtIndex(index: Int) -> ScreenPreviewViewProtocol {
        let size                   = CGSize(width: UIScreen.mainScreen().bounds.width * 0.6, height: UIScreen.mainScreen().bounds.height * 0.6)
        let screenView             = ScreenPreviewView(frame: CGRect(origin: CGPoint.zero, size: size))
        let previewable            = previewableScreens[index]
        let previewImage: UIImage? = previewable.thumbnailImage
        guard let vc = previewable as? UIViewController else {
            fatalError()
        }
        let titleText: String?     = vc.title
        screenView.titleLabel.text = titleText
        screenView.imageView.image = previewImage
        return screenView
    }
    
    // MARK: -
    
    func animationControllerForPresentedController(presented: UIViewController,
                                                          presentingController presenting: UIViewController,
                                                                               sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ScreenSelectorTransitioningAnimator(isReverse: false, moveFromImageView: transitionFromPreviewImageView)
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ScreenSelectorTransitioningAnimator(isReverse: true, moveFromImageView: transitionFromPreviewImageView)
        return animator
    }
    
}

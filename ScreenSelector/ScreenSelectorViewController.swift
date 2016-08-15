//
//  ScreenSelectorViewController.swift
//  ScreenSelectorExample
//
//  Created by Tomonori Ueno on 2016/07/22.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit

public class ScreenSelectorViewController: UIViewController, ScreenSelectorViewDelegate, ScreenSelectorViewDataSource, UIViewControllerTransitioningDelegate {

    public let screenSelectorView = ScreenSelectorView()
    public var previewableScreens: [ScreenSelectorPreviewable] = []

    weak var transitionFromPreviewImageView: UIImageView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        screenSelectorView.frame      = view.bounds
        screenSelectorView.delegate   = self
        screenSelectorView.dataSource = self
        view.addSubview(screenSelectorView)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - ScreenSelectorViewDelegate
    
    public func screenSelectorViewDidTapScreenAtIndex(index: Int, previewView: ScreenPreviewViewProtocol) {
        transitionFromPreviewImageView = previewView.imageView
        if let viewController = previewableScreens[index] as? UIViewController {
            viewController.transitioningDelegate = self
            presentViewController(viewController, animated: true) {
                // Move selected preview to center of screen.
                self.screenSelectorView.scrollToIndex(index, animated: false)
            }
        }
    }
    
    // MARK: - ScreenSelectorViewDataSource
    
    public func numberOfScreens() -> Int {
        return previewableScreens.count
    }
    
    public func previewViewForScreenAtIndex(index: Int) -> ScreenPreviewViewProtocol {
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
    
    public func animationControllerForPresentedController(presented: UIViewController,
                                                          presentingController presenting: UIViewController,
                                                                               sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ScreenSelectorTransitioningAnimator(isReverse: false, moveFromImageView: transitionFromPreviewImageView)
        return animator
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ScreenSelectorTransitioningAnimator(isReverse: true, moveFromImageView: transitionFromPreviewImageView)
        return animator
    }
    
}

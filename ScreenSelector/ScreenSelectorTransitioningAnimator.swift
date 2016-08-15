//
//  ScreenSelectorTransitioningAnimator.swift
//
//  Created by Tomonori Ueno on 2016/05/10.
//  Copyright © 2016年 Tomonori Ueno All rights reserved.
//

import UIKit

final public class ScreenSelectorTransitioningAnimator: NSObject, ReversibleAnimatedTransitioning {

    weak var moveFromImageView: UIImageView?
    public var isReverse: Bool
    
    override required public init() {
        isReverse = false
        super.init()
    }
    
    required public init(isReverse: Bool = false, moveFromImageView: UIImageView?) {
        self.isReverse         = isReverse
        self.moveFromImageView = moveFromImageView
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            containerView = transitionContext.containerView() else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }
        
        let fromView = fromVC.view
        let toView   = toVC.view
        let generateCopyOfImageView: UIImageView? -> UIImageView? = { view in
            guard let view = view else {
                return nil
            }
            toView.layoutIfNeeded()
            let copy                 = UIImageView(image: view.image)
            copy.contentMode         = view.contentMode
            copy.frame               = containerView.convertRect(view.frame, fromView: view.superview)
            copy.layer.masksToBounds = true
            return copy
        }
        if toView.frame == CGRect.zero {
            toView.frame = fromView.frame
        }
        let copiedImageView: UIImageView?
        let moveFromView: UIView?
        let moveToView: UIView?
        if let f = fromVC as? ScreenSelectorPreviewable where isReverse {
            containerView.insertSubview(toView, belowSubview: fromView)
            moveFromView  = f.backgroundImageView
            copiedImageView = generateCopyOfImageView(moveFromView as? UIImageView)
            moveToView    = moveFromImageView
        } else if let t = toVC as? ScreenSelectorPreviewable where !isReverse {
            containerView.addSubview(toView)
            moveFromView  = moveFromImageView
            copiedImageView = generateCopyOfImageView(moveFromView as? UIImageView)
            moveToView    = t.backgroundImageView
        } else {
            fatalError()
        }
        
        if let moveToView = moveToView, copiedImageView = copiedImageView, moveFromImageView = moveFromImageView {
            containerView.addSubview(copiedImageView)
            let duration        = transitionDuration(transitionContext)
            let toFrame: CGRect
            if isReverse {
                fromView.hidden = true
                toFrame = containerView.convertRect(moveFromImageView.frame, fromView: moveFromImageView.superview)
            } else {
                toView.alpha = 0
                toFrame = containerView.convertRect(moveToView.frame, fromView: moveToView.superview)
            }
            
            UIView.animateWithDuration(duration * 0.6, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: {
                copiedImageView.frame = toFrame
            }) { (finished) in
                if self.isReverse {
                    fromView.hidden = false
                    // 完了通知
                    copiedImageView.removeFromSuperview()
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
                } else {
                    containerView.insertSubview(toView, aboveSubview: copiedImageView)
                    UIView.animateWithDuration(duration * 0.4, delay: 0, options: [.BeginFromCurrentState], animations: {
                        toView.alpha = 1.0
                    }) { (finished) in
                        fromView.hidden = false
                        // 完了通知
                        copiedImageView.removeFromSuperview()
                        let isCancelled = transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(!isCancelled)
                    }
                }
            }
        } else {
            let isCancelled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(!isCancelled)
        }
        
    }
    
}

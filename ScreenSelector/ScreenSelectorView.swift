//
//  ScreenSelectorView.swift
//  ScreenSelector
//
//  Created by Tomonori Ueno on 2016/07/20.
//  Copyright © 2016年 Tomonori Ueno. All rights reserved.
//

import UIKit

public protocol ScreenSelectorViewDelegate: class {
    func screenSelectorViewDidTapScreenAtIndex(index: Int, previewView: ScreenPreviewViewProtocol)
}
public protocol ScreenSelectorViewDataSource: class {
    func numberOfScreens() -> Int
    func previewViewForScreenAtIndex(index: Int) -> ScreenPreviewViewProtocol
}

@IBDesignable
public class ScreenSelectorView: UIView {

    @IBInspectable public var horizontalMargin: CGFloat      = 20
    @IBInspectable public var previewVerticalOffset: CGFloat = 0
    @IBInspectable public var previewReflectionEnabled: Bool = false
    
    public let scrollView: UIScrollView = UIScrollView()
    public weak var delegate: ScreenSelectorViewDelegate?
    public weak var dataSource: ScreenSelectorViewDataSource? {
        didSet {
            reloadData()
        }
    }
    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        didSet {
            scrollView.delegate = scrollViewDelegate
        }
    }
    private var previewViews: [ScreenPreviewViewProtocol] = []
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        scrollView.frame = bounds
        reloadData(dataSource: DummyScreenDataSource())
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        setScrollViewHorizontalInset()
    }
    
    private func commonInit() {
        setupScrollView()
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapRecog)
        scrollView.delegate = scrollViewDelegate
        scrollView.frame    = bounds
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceHorizontal         = true
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
    }
    
    private func reloadData(dataSource dataSource: ScreenSelectorViewDataSource?) {
        guard let dataSource = dataSource where dataSource.numberOfScreens() > 0 else {
            return
        }
        removeAllPreviews()
        for i in 0.stride(to: dataSource.numberOfScreens(), by: 1) {
            let contentView = dataSource.previewViewForScreenAtIndex(i)
            previewViews.append(contentView)
            guard let c = contentView as? UIView else {
                fatalError()
            }
            var contentViewFrame      = c.frame
            contentViewFrame.origin.x = CGFloat(i) * (horizontalMargin + contentViewFrame.size.width)
            c.frame                   = contentViewFrame
            c.center                  = CGPoint(x: c.center.x, y: bounds.height * 0.5 + previewVerticalOffset)
            scrollView.addSubview(c)
            scrollView.contentSize    = CGSize(width: contentViewFrame.maxX, height: 0)
            if previewReflectionEnabled {
                addSpecularReflectionLayerToView(c)
            }
        }
        setScrollViewHorizontalInset()
    }
    
    private func setScrollViewHorizontalInset() {
        // Calculate horizontal inset to place first screen to center.
        let contentViewBounds = previewViews
            .map() { view in
                return view as? UIView
            }
            .flatMap() { a in a }
            .first?.bounds ?? CGRect.zero
        let horizontalInset           = scrollView.bounds.width * 0.5 - contentViewBounds.width * 0.5
        scrollView.contentInset.left  = horizontalInset
        scrollView.contentInset.right = horizontalInset
        scrollView.setContentOffset(CGPoint(x: -scrollView.contentInset.left, y: 0), animated: false)
    }
    
    private func addSpecularReflectionLayerToView(view: UIView) {
        let layer = SpecularReflectionLayer(sourceView: view)
        view.layer.addSublayer(layer)
    }
    
    private func removeAllPreviews() {
        previewViews.forEach { (previewView) in
            if let view = previewView as? UIView {
                view.removeFromSuperview()
            }
        }
        previewViews.removeAll()
    }
    
    public func reloadData() {
        reloadData(dataSource: dataSource)
    }
    
    public func scrollToIndex(index: Int, animated: Bool) {
        guard previewViews.count > index else {
            return
        }
        if let preview = previewViews[index] as? UIView {
            let xOffset = -(scrollView.bounds.width * 0.5 - (preview.frame.maxX - preview.bounds.midX))
            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: animated)
        }
    }
    
    func tapped(tapRecog: UITapGestureRecognizer) {
        let location   = tapRecog.locationInView(self)
        let tappedView = previewViews
            .filter { (view) -> Bool in
                guard let view = view as? UIView else {
                    return false
                }
                let rectInView = scrollView.convertRect(view.frame, toView: self)
                return rectInView.contains(location)
            }
            .first
        let index = previewViews
            .indexOf { (viewProtocol) -> Bool in
                return viewProtocol === tappedView
        }
        if let t = tappedView, index = index {
            self.delegate?.screenSelectorViewDidTapScreenAtIndex(index, previewView: t)
        }
    }
    
}

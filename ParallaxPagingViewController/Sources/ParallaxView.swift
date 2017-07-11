//
//  ParallaxView.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/06.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

@IBDesignable
open class ParallaxView: UIView {

    open let backgroundImageView = UIImageView()
    
    @IBInspectable
    open var parallaxImage: UIImage? {
        didSet {
            backgroundImageView.image = parallaxImage
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
    }
    
    fileprivate func initialize() {
        clipsToBounds = true
        autoresizingMask = [.flexibleWidth,.flexibleHeight]
        backgroundImageView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(backgroundImageView)
    }
    
    internal func parallaxAnimate(_ space: CGFloat, rate: CGFloat, position: PagePosition) {
        let originX: CGFloat
        switch position {
        case .after:
            originX = -space*rate - space
        case .before:
            originX = -space*rate + space
        case .current:
            originX = -space*rate
        }
        backgroundImageView.frame.origin.x = originX
    }
    
}

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

    public let backgroundImageView = UIImageView()
    
    @IBInspectable
    public var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initiarize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initiarize()
    }
    
    fileprivate func initiarize() {
        clipsToBounds = true
        autoresizingMask = [.flexibleWidth,.flexibleHeight]
        backgroundImageView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        backgroundImageView.frame = bounds
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

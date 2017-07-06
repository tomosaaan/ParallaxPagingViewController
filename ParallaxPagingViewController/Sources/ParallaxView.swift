//
//  ParallaxView.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/06.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit


@IBDesignable
class ParallaxView: UIView {

    let backgroundImageView = UIImageView()
    
    @IBInspectable
    var backgroundImage: UIImage? {
        willSet {
            backgroundImageView.image = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initiarize()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    func parallaxAnimate(_ space: CGFloat, rate: CGFloat, position: PagePosition) {
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

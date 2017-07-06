//
//  ParallaxPagingViewControllerEnums.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

enum ScrollDirection {
    case stop
    case left
    case right
}

enum PagePosition {
    case current
    case after
    case before
}

enum ParallaxPagingViewOption {
    case pageSpace
    case parallaxSpace
    
    func cgfloatValue(_ value: Any) -> CGFloat{
        if let number = value as? NSNumber {
            return CGFloat(number.floatValue)
        }
        return 0.0
    }
    
}

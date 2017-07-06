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

public enum ParallaxPagingViewOption: String {
    case pageSpace
    case parallaxSpace
}

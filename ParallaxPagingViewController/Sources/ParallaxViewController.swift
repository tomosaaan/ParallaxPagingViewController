//
//  ParallaxViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

open class ParallaxViewController: UIViewController {
    
    open var backgroundView = ParallaxView()
    
    @IBInspectable
    open var parallaxImage: UIImage? {
        didSet {
            backgroundView.parallaxImage = parallaxImage
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.frame = view.bounds
        view.addSubview(backgroundView)
        
        // For xib & storyboard
        view.sendSubview(toBack: backgroundView)
        view.subviews.forEach{ $0.bringSubview(toFront: backgroundView) }
    }
}

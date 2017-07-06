//
//  ParallaxViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

open class ParallaxViewController: UIViewController {
    
    internal var backgroundView: ParallaxView! {
        get {
            if let backView = view as? ParallaxView {
                return backView
            }
            return nil
        }
        set {
            view = newValue
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
    }

    fileprivate func setupBackgroundView() {
        let parallaxView = ParallaxView()
        parallaxView.frame = view.bounds
        backgroundView = parallaxView
    }

    public func setParallaxImage(_ image: UIImage?) {
        backgroundView.backgroundImage = image
    }
}

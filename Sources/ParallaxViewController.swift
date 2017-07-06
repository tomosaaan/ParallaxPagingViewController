//
//  ParallaxViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

class ParallaxViewController: UIViewController {
    
    fileprivate(set) var backgroundView: ParallaxView! {
        get {
            if let backView = view as? ParallaxView {
                return backView
            }
            return nil
        }
        set {
            if !(view is ParallaxView) {
                view = newValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
    }

    fileprivate func setupBackgroundView() {
        backgroundView = ParallaxView()
    }

}

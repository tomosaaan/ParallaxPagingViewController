//
//  ParallaxViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit


open class ParallaxViewController: UIViewController {
    
    public var backgroundView = ParallaxView()
    
    @IBInspectable
    public var image: UIImage? {
        didSet {
            backgroundView.backgroundImage = image!
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.frame = view.bounds
        view.addSubview(backgroundView)
        
    }

    public func setParallaxImage(_ image: UIImage) {
        backgroundView.backgroundImage = image
    }
}

//
//  ParallaxChildViewController.swift
//  ParallaxPagingViewControllerExample
//
//  Created by takahashi tomoki on 2017/07/06.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit
import ParallaxPagingViewController

class ParallaxChildViewController: ParallaxViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        parallaxImage = UIImage(named: "sample")
    }
}

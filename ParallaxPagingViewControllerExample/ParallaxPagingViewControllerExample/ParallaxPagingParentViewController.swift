//
//  ViewController.swift
//  ParallaxPagingViewControllerExample
//
//  Created by takahashi tomoki on 2017/07/06.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit
import ParallaxPagingViewController

class ParallaxPagingParentViewController: ParallaxPagingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pageSpace = 20
        parallaxSpace = 50
        
        setViewControllers(controllers: [
            ParallaxChildViewController(),
            ParallaxChildViewController(),
            ParallaxChildViewController(),
        ])
        
        setInfinite(true)
    }

}
extension ParallaxPagingParentViewController: ParallaxPagingViewControllerDelegate{
    func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, willMoveTo viewController: ParallaxViewController) {
    }
    
    func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, didMoveTo viewController: ParallaxViewController) {
        
    }
    
}


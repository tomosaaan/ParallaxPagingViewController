//
//  ParallaxChildViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/06.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit
import ParallaxPagingViewController

class ParallaxChildViewController: ParallaxViewController {
    
    var index: Int = 0
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.frame = CGRect(x: view.bounds.width/2 - 50, y: view.bounds.height/2 - 50, width: 100, height: 100)
        label.text = "\(index)"
        view.addSubview(label)
        setParallaxImage(UIImage(named: "sample"))
    }




}

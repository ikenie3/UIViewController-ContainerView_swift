//
//  ChildViewController.swift
//  UIViewController+ContainerViewDemo
//
//  Created by Matsui Akihiro on 2016/02/17.
//  Copyright © 2016年 ikenie3.org. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {
    
    // MARK: -- Actions
    
    // MARK: -- Outlets
    
    // MARK: -- View lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        // do something
        
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // do something
    }
    
    
    // MARK: -- Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

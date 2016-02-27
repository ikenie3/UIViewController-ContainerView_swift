//
//  ViewController.swift
//  UIViewController+ContainerViewDemo
//
//  Created by ikenie3 on 2016/02/16.
//  Copyright © 2016年 ikenie3.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: -- Action
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        
        guard let vc = self.buildChildViewController() else {
            return
        }

        self.vcc_addChildViewController(vc, containerView: containerView, animated: true,
            beforeBlock: { (viewController: UIViewController?) -> Void in
                
            },
            animationBlock: { (viewController: UIViewController?) -> Void in
                
            },
            finalyBlock: { (viewController: UIViewController?) -> Void in
                
            }
        )
    }
    
    @IBAction func removeButtonPressed(sender: AnyObject) {
        
        guard let vc = self.vcc_childViewControllers.last else {
            return
        }
        
        self.vcc_removeChildViewController(vc, containerView: containerView, animated: true,
            beforeBlock: { (viewController) -> Void in
                
            }, animationBlock: { (viewController) -> Void in
                
            }, finalyBlock: { (viewController) -> Void in
                
            }
        )
    }
    
    @IBAction func pushButtonPressed(sender: AnyObject) {
        
        guard let vc = self.buildChildViewController() else {
            return
        }
        
        self.vcc_pushChildViewController(vc, containerView: containerView, animated: true,
            beforeBlock: { (fromViewController, toViewController) -> Void in
                
            },
            animationBlock: { (fromViewController, toViewController) -> Void in
                
            },
            finalyBlock:  { (fromViewController, toViewController) -> Void in
                
            }
        )
    }
    
    @IBAction func popButtonPressed(sender: AnyObject) {
        
        self.vcc_popChildViewController(true,
            beforeBlock: { (fromViewController, toViewController) -> Void in
                
            },
            animationBlock: { (fromViewController, toViewController) -> Void in
                
            },
            finalyBlock: { (fromViewController, toViewController) -> Void in
                
            }
        )
    }
    
    @IBAction func swapButtonPressed(sender: AnyObject) {
        
        guard let vc = self.buildChildViewController() else {
            return
        }
        
        self.vcc_swapChildViewController(vc, containerView: containerView, animated: true,
            beforeBlock: { (fromViewController, toViewController) -> Void in
                
            },
            animationBlock: { (fromViewController, toViewController) -> Void in
                
            },
            finalyBlock: { (fromViewController, toViewController) -> Void in
                
            }
        )
        
    }
    
    private var index: Int = 0
    
    func buildChildViewController() -> ChildViewController? {
        guard let vc: ChildViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChildViewController") as? ChildViewController else {
            return nil
        }
        
        let colors = [
            UIColor.redColor(),
            UIColor.blueColor(),
            UIColor.purpleColor(),
            UIColor.magentaColor(),
            UIColor.cyanColor(),
            UIColor.yellowColor(),
            UIColor.grayColor(),
            UIColor.orangeColor(),
        ]
        
        while (true) {
            let rand = Int(arc4random_uniform(UInt32(colors.count)))
            if rand != index {
                index = rand
                break
            }
        }
        vc.view.backgroundColor = colors[index]
        return vc
    }
    
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


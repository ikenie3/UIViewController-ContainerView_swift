//
//  UIViewController+ContainerView.swift
//  UIViewController+ContainerView
//
//  Created by ikenie3 on 2016/02/16.
//  Copyright © 2016年 ikenie3.org. All rights reserved.
//

import Foundation
import UIKit

public typealias VCC_VoidBlock = (Void) -> Void
public typealias VCC_SimpleBlock = (viewController: UIViewController?) -> Void
public typealias VCC_TransitionBlock = (fromViewController: UIViewController?, toViewController: UIViewController?) -> Void


// MARK: - VCCTransitionProtocol

/**
 VCCTransitionProtocol
 ============

 This protocol, only to define the method.
*/
@objc
protocol VCCTransitionProtocol {
    
    /**
     add child viewcontroller.
     */
    func vcc_addChildViewController(toViewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_SimpleBlock?, animationBlock: VCC_SimpleBlock?, finalyBlock: VCC_SimpleBlock?) -> Void
    
    /**
     remove child viewcontroller.
     */
    func vcc_removeChildViewController(fromViewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_SimpleBlock?, animationBlock: VCC_SimpleBlock?, finalyBlock: VCC_SimpleBlock?) -> Void
    
    /**
     push child viewcontroller. like UINavigationController pushViewController:
     */
    func vcc_pushChildViewController(toViewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_TransitionBlock?, animationBlock: VCC_TransitionBlock?, finalyBlock: VCC_TransitionBlock?) -> Void
    
    /**
     pop child viewcontroller. like UINavigationController popViewController:
     */
    func vcc_popChildViewController(animated: Bool, beforeBlock: VCC_TransitionBlock?, animationBlock: VCC_TransitionBlock?, finalyBlock: VCC_TransitionBlock?) -> Void
    
    /**
     swap child viewcontroller only when have child viewcontroller.
     when child is not exist, call vcc_addChildViewController()
     */
    func vcc_swapChildViewController(viewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_TransitionBlock?, animationBlock: VCC_TransitionBlock?, finalyBlock: VCC_TransitionBlock?) -> Void
    
}


// MARK: - UIViewController: VCCTransitionProtocol
extension UIViewController: VCCTransitionProtocol {
    
    /**
     Associated Objects structs
     
     reference: [http://nshipster.com/swift-objc-runtime/](http://nshipster.com/swift-objc-runtime/)
     */
    private struct AssociatedKeys {
        static var ChildViewControllerName = "vcc_childViewControllers"
    }
    
    /**
     property for class extention
     */
    var vcc_childViewControllers: [UIViewController] {
        get {
            guard let result: [UIViewController] = objc_getAssociatedObject(self, &AssociatedKeys.ChildViewControllerName) as? [UIViewController] else {
                return []
            }
            return result
        }
        set {
            if let newValue: [UIViewController] = newValue {
                objc_setAssociatedObject(self,
                    &AssociatedKeys.ChildViewControllerName,
                    newValue as [UIViewController],
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    
    // MARK: -- VCCTransitionProtocol methods
    /**
     add child view controller.
     TODO: comment
     */
    func vcc_addChildViewController(toViewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_SimpleBlock?, animationBlock: VCC_SimpleBlock?, finalyBlock: VCC_SimpleBlock?) -> Void {
        
        let b: VCC_SimpleBlock? = beforeBlock
        let a: VCC_SimpleBlock? = animationBlock
        let f: VCC_SimpleBlock? = finalyBlock
        
        // update viewControllers
        toViewController.beginAppearanceTransition(true, animated: false)
        containerView.addSubview(toViewController.view)
        
        weak var wself = self
        
        var viewControllers = self.vcc_childViewControllers
        viewControllers.append(toViewController)
        self.vcc_childViewControllers = viewControllers

        // start transition
        self.vcc_transition(animated,
            before: { (Void) -> Void in
                b?(viewController: toViewController)
            },
            animation: { (Void) -> Void in
                toViewController.view.frame = containerView.bounds
                a?(viewController: toViewController)
            },
            finaly: { (Void) -> Void in
                toViewController.didMoveToParentViewController(wself)
                toViewController.endAppearanceTransition()
                f?(viewController: toViewController)
            }
        )

    }
    
    /**
     remove child view controller.
     TODO: comment
     */
    func vcc_removeChildViewController(fromViewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_SimpleBlock?, animationBlock: VCC_SimpleBlock?, finalyBlock: VCC_SimpleBlock?) -> Void {
        
        let b: VCC_SimpleBlock? = beforeBlock
        let a: VCC_SimpleBlock? = animationBlock
        let f: VCC_SimpleBlock? = finalyBlock
        
        // update viewControllers
        fromViewController.beginAppearanceTransition(false, animated: false)
        fromViewController.willMoveToParentViewController(nil)
        
        // start transition
        self.vcc_transition(animated,
            before: { (Void) -> Void in
                b?(viewController: fromViewController)
            },
            animation: { (Void) -> Void in
                fromViewController.view.frame = containerView.bounds
                a?(viewController: fromViewController)
            },
            finaly: { (Void) -> Void in
                f?(viewController: fromViewController)
                
                // remove parent view controller
                fromViewController.view.removeFromSuperview()
                fromViewController.removeFromParentViewController()
                fromViewController.endAppearanceTransition()
                
                var viewControllers = self.vcc_childViewControllers
                if let index = viewControllers.indexOf(fromViewController) {
                    viewControllers.removeAtIndex(index)
                    self.vcc_childViewControllers = viewControllers
                }
                
            }
        )
    }
    
    /**
     like navigation controller pushViewController(:animated:)
     TODO: comment
     */
    func vcc_pushChildViewController(toViewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_TransitionBlock?, animationBlock: VCC_TransitionBlock?, finalyBlock: VCC_TransitionBlock?) -> Void {
        var viewControllers = self.vcc_childViewControllers
        
        let b: VCC_TransitionBlock? = beforeBlock
        let a: VCC_TransitionBlock? = animationBlock
        let f: VCC_TransitionBlock? = finalyBlock
        
        guard let from = viewControllers.last else {
            /*
             not have child view controller
             */
            self.vcc_addChildViewController(toViewController, containerView: containerView, animated: animated,
                beforeBlock: { (viewController: UIViewController?) -> Void in
                    b?(fromViewController: nil, toViewController: viewController)
                },
                animationBlock: { (viewController: UIViewController?) -> Void in
                    a?(fromViewController: nil, toViewController: viewController)
                },
                finalyBlock: { (viewController: UIViewController?) -> Void in
                    f?(fromViewController: nil, toViewController: viewController)
                }
            )
            
            return
        }
        
        viewControllers.append(toViewController)
        self.vcc_childViewControllers = viewControllers
        
        // remove fromViewController
        from.beginAppearanceTransition(false, animated: false)
        from.willMoveToParentViewController(nil)
        
        // add toViewController
        self.addChildViewController(toViewController)
        toViewController.beginAppearanceTransition(true, animated: false)
        containerView.addSubview(toViewController.view)
        
        // start transition
        self.vcc_transition(animated,
            before: { (Void) -> Void in
                b?(fromViewController: from, toViewController: toViewController)
            },
            animation: { (Void) -> Void in
                toViewController.view.frame = containerView.bounds
                a?(fromViewController: from, toViewController: toViewController)
            },
            finaly: { (Void) -> Void in
                f?(fromViewController: from, toViewController: toViewController)
                
                // remove parent view controller
                from.view.removeFromSuperview()
                from.removeFromParentViewController()
                from.endAppearanceTransition()
            }
        )
        
    }
    
    /**
     like navigation controller popViewControllerAnimated:
     TODO: comment
     */
    func vcc_popChildViewController(animated: Bool, beforeBlock: VCC_TransitionBlock?, animationBlock: VCC_TransitionBlock?, finalyBlock: VCC_TransitionBlock?) -> Void {
        let b: VCC_TransitionBlock? = beforeBlock
        let a: VCC_TransitionBlock? = animationBlock
        let f: VCC_TransitionBlock? = finalyBlock
        
        var viewControllers: [UIViewController] = self.vcc_childViewControllers
        if viewControllers.count < 2 {
            return
        }
        
        let from: UIViewController = viewControllers.last!
        let fromIndex = viewControllers.indexOf(from)!
        let to: UIViewController = viewControllers[fromIndex-1]
        
        // remove
        from.beginAppearanceTransition(false, animated: false)
        from.willMoveToParentViewController(nil)
        
        self.addChildViewController(to)
        to.didMoveToParentViewController(self)
        to.beginAppearanceTransition(true, animated: false)
        from.view.superview?.insertSubview(to.view, aboveSubview: from.view)
        
        self.vcc_transition(animated,
            before: { (Void) -> Void in
                b?(fromViewController: from, toViewController: to)
            },
            animation: { (Void) -> Void in
                a?(fromViewController: from, toViewController: to)
            },
            finaly: { (Void) -> Void in
                // add finalize
                to.didMoveToParentViewController(self)
                
                // remove finalize
                from.view.removeFromSuperview()
                from.removeFromParentViewController()
                from.endAppearanceTransition()
                
                if let index = viewControllers.indexOf(from) {
                    viewControllers.removeAtIndex(index)
                    self.vcc_childViewControllers = viewControllers
                }
                
                f?(fromViewController: from, toViewController: to)
            }
        )
    }
    
    /**
     replace current viewController
     TODO: comment
     */
    func vcc_swapChildViewController(viewController: UIViewController, containerView: UIView, animated: Bool, beforeBlock: VCC_TransitionBlock?, animationBlock: VCC_TransitionBlock?, finalyBlock: VCC_TransitionBlock?) -> Void {
        
        let b: VCC_TransitionBlock? = beforeBlock
        let a: VCC_TransitionBlock? = animationBlock
        let f: VCC_TransitionBlock? = finalyBlock
        
        let to: UIViewController = viewController
        
        var viewControllers = self.vcc_childViewControllers
        
        guard let from = viewControllers.last else {
            self.vcc_addChildViewController(viewController, containerView: containerView, animated: animated,
                beforeBlock: { (viewController: UIViewController?) -> Void in
                    b?(fromViewController: nil, toViewController: viewController)
                }, animationBlock: { (viewController: UIViewController?) -> Void in
                    a?(fromViewController: nil, toViewController: viewController)
                }, finalyBlock: { (viewController: UIViewController?) -> Void in
                    f?(fromViewController: nil, toViewController: viewController)
                }
            )
            
            return
        }
        
        viewControllers.append(to)
        self.vcc_childViewControllers = viewControllers
        
        // remove
        from.beginAppearanceTransition(false, animated: false)
        from.willMoveToParentViewController(nil)
        
        // add 
        self.addChildViewController(to)
        to.beginAppearanceTransition(true, animated: false)
        containerView.addSubview(to.view)
        
        self.vcc_transition(animated,
            before: { (Void) -> Void in
                b?(fromViewController: from, toViewController: to)
            },
            animation: { (Void) -> Void in
                a?(fromViewController: from, toViewController: to)
            },
            finaly: { (Void) -> Void in
                // add finalize
                to.didMoveToParentViewController(self)
                to.endAppearanceTransition()
                
                // remove finalize
                from.view.removeFromSuperview()
                from.removeFromParentViewController()
                from.endAppearanceTransition()
                
                if let index = viewControllers.indexOf(from) {
                    viewControllers.removeAtIndex(index)
                    self.vcc_childViewControllers = viewControllers
                }
                
                f?(fromViewController: from, toViewController: to)
            }
        )
        
    }
    
    
    // MARK: -- Private methods
    
    /**
     TODO: comment
     */
    private class func vcc_beginIgnoringInteractionEvents() {
        let application = UIApplication.sharedApplication()
        if !application.isIgnoringInteractionEvents() {
            application.beginIgnoringInteractionEvents()
        }
    }
    
    /**
     TODO: comment
     */
    private class func vcc_endIgnoringInteractionEvents() {
        let application = UIApplication.sharedApplication()
        if application.isIgnoringInteractionEvents() {
            application.endIgnoringInteractionEvents()
        }
    }
    
    /**
     TODO: comment
     */
    private func vcc_transition(animated: Bool, before: VCC_VoidBlock, animation: VCC_VoidBlock, finaly: VCC_VoidBlock) {
        if animated {
            // begin ignore touch event
            self.dynamicType.vcc_beginIgnoringInteractionEvents()
            
            // before block
            before()
            
            // animation blcok
            UIView.animateWithDuration(NSTimeInterval(0.3),
                animations: { () -> Void in
                    animation()
                },
                completion: { (Bool) -> Void in
                    // end ignore touch event
                    self.dynamicType.vcc_endIgnoringInteractionEvents()
                    
                    // finaly
                    finaly()
                }
            )
        }
        else {
            // begin ignore touch event
            self.dynamicType.vcc_beginIgnoringInteractionEvents()
            
            // before
            before()
            // animation
            animation()
            // finaly
            finaly()
            
            // end ignore touch event
            self.dynamicType.vcc_endIgnoringInteractionEvents()
        }
        
    }
    
}

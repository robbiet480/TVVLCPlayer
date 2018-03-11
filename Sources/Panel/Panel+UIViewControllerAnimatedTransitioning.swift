//
//  PanelPresentation.swift
//  Pods-Demo
//
//  Created by Jérémy Marchand on 09/03/2018.
//

import Foundation

fileprivate let animatonDuration = 0.6

// MARK: SlideDown
class SlideDownUIViewControllerAnimatedTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animatonDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let secondVCView = transitionContext.view(forKey: .to), let secondVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let firstVCView = transitionContext.containerView
        firstVCView.addSubview(secondVCView)
        
        let rect =  secondVC.preferredContentSize
        secondVCView.frame.size = rect
        secondVCView.frame.origin.y = -secondVCView.frame.height
        
        UIView.animate(withDuration: animatonDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            secondVCView.frame.origin.y = 0
        }, completion: { completed in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}

// MARK: SlideUp
class SlideUpUIViewControllerAnimatedTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animatonDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let secondVCView = transitionContext.view(forKey: .from) else {
            return
        }
        
        secondVCView.frame.origin.y = 0
        UIView.animate(withDuration: animatonDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            secondVCView.frame.origin.y = -secondVCView.frame.height
        }, completion: { completed in
            secondVCView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
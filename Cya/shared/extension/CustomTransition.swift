//
//  CustomTransition.swift
//  Cya
//
//  Created by Rigo on 28/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

enum TransitionType {
    case Presenting, Dismissing
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    var duration: TimeInterval
    var isPresenting: Bool
    var originFrame: CGRect
    
    init(withDuration duration: TimeInterval, forTransitionType type: TransitionType, originFrame: CGRect) {
        self.duration = duration
        self.isPresenting = type == .Presenting
        self.originFrame = originFrame
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        
        let detailView = self.isPresenting ? toView : fromView
        
        if self.isPresenting {
            containerView.addSubview(toView!)
        } else {
            containerView.insertSubview(toView!, belowSubview: fromView!)
        }
        
        detailView?.frame.origin = self.isPresenting ? self.originFrame.origin : CGPoint(x: 0, y: 0)
        detailView?.frame.size.width = self.isPresenting ? self.originFrame.size.width : containerView.bounds.width
        detailView?.layoutIfNeeded()
        
        for view in (detailView?.subviews)! {
            if !(view is UIImageView) {
                view.alpha = isPresenting ? 0.0 : 1.0
            }
        }
        
        UIView.animate(withDuration: self.duration, animations: { () -> Void in
            detailView?.frame = self.isPresenting ? containerView.bounds : self.originFrame
            detailView?.layoutIfNeeded()
            
            for view in (detailView?.subviews)! {
                if !(view is UIImageView) {
                    view.alpha = self.isPresenting ? 1.0 : 0.0
                }
            }
        }) { (completed: Bool) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
}




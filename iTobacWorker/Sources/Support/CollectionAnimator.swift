//
//  Animator.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.02.2022.
//

import Foundation
import UIKit

final class CollectionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    static let duration: TimeInterval = 0.7

    private let firstViewController: BrandsViewController
    private let secondViewController: SingleBrandViewController
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect
    private let cellLabelRect: CGRect

    init?(firstViewController: BrandsViewController, secondViewController: SingleBrandViewController, selectedCellImageViewSnapshot: UIView) {
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window,
            let selectedCell = firstViewController.selectedCell
            else { return nil }

        self.cellImageViewRect = selectedCell.brandImageView.convert(selectedCell.brandImageView.bounds, to: window)

        self.cellLabelRect = selectedCell.brandLabel.convert(selectedCell.brandLabel.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      
        guard let toView = secondViewController.view else {
                transitionContext.completeTransition(false)
                return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        guard
            let window = firstViewController.view.window ?? secondViewController.view.window,
            let selectedCell = firstViewController.selectedCell,
            let cellImageSnapshot = selectedCell.brandImageView.snapshotView(afterScreenUpdates: true),
            let controllerImageSnapshot = secondViewController.singleBrandView.brandImageView.snapshotView(afterScreenUpdates: true),
            let controllerLabelSnapshot =  secondViewController.singleBrandView.brandLabel.snapshotView(afterScreenUpdates: true),
            let controllerButtonSnapshot = secondViewController.singleBrandView.closeButton.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(true)
                return
        }

        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = secondViewController.view.backgroundColor

        selectedCellImageViewSnapshot = cellImageSnapshot
        backgroundView = UIView(frame: containerView.bounds)
        backgroundView.addSubview(fadeView)
        fadeView.alpha = 0
        toView.alpha = 0

        [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot, controllerLabelSnapshot, controllerButtonSnapshot].forEach { containerView.addSubview($0) }

        let controllerImageViewRect = secondViewController.singleBrandView.brandImageView.convert(secondViewController.singleBrandView.brandImageView.bounds, to: window)
        let controllerLabelRect = secondViewController.singleBrandView.brandLabel.convert(secondViewController.singleBrandView.brandLabel.bounds, to: window)
        let closeButtonRect = secondViewController.singleBrandView.closeButton.convert(secondViewController.singleBrandView.closeButton.bounds, to: window)

        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = cellImageViewRect
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }

        controllerImageSnapshot.alpha = 0
        selectedCellImageViewSnapshot.alpha = 1

        
        controllerLabelSnapshot.frame = cellLabelRect
        controllerButtonSnapshot.frame = closeButtonRect
        controllerButtonSnapshot.alpha = 0

        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.selectedCellImageViewSnapshot.frame = controllerImageViewRect
                fadeView.alpha = 1
                
                controllerImageSnapshot.frame = controllerImageViewRect
                controllerLabelSnapshot.frame = controllerLabelRect
                [controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
                    $0.layer.cornerRadius = 0
                }
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = 0
                controllerImageSnapshot.alpha = 1
            }

            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                controllerButtonSnapshot.alpha = 1
            }
        }, completion: { _ in
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            controllerLabelSnapshot.removeFromSuperview()
            controllerButtonSnapshot.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}

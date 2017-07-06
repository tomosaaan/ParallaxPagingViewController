//
//  ParllaxPagingViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

protocol ParallaxPagingViewControllerDelegate: class {
    func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, willMoveTo viewController:ParallaxViewController)
    func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, didMoveTo viewController:ParallaxViewController)
}

class ParallaxPagingViewController: UIViewController {
    
    weak var delegate: ParallaxPagingViewControllerDelegate? = nil
    
    internal let containerScrollView = UIScrollView()
    
    fileprivate let controllers: [ParallaxViewController]
    
    internal var visibleViewControllers = [ParallaxViewController]()
    
    fileprivate var scrollDirection: ScrollDirection {
        let controller = controllers[currentPageIndex]
        if controller.view.frame.origin.x - pageSpace/2 < containerScrollView.contentOffset.x {
            return .right
        } else if controller.view.frame.origin.x - pageSpace/2 > containerScrollView.contentOffset.x {
            return .left
        }
        return .stop
    }
    
    fileprivate var pagingEnabled: Bool {
        let offsetX = containerScrollView.contentOffset.x
        return 0 <= offsetX && offsetX <= containerScrollView.contentSize.width - (view.bounds.width + pageSpace)
    }

    fileprivate var didEndDisplay: Bool {
        var value = false
        switch scrollDirection {
        case .left:
            if frame(at: .before).origin.x-pageSpace/2 >= containerScrollView.contentOffset.x {
                value = isVisible(controllers[beforePageIndex])
            }
        case .right:
            if frame(at: .after).origin.x-pageSpace/2 <= containerScrollView.contentOffset.x {
                value = isVisible(controllers[afterPageIndex])
            }
        case .stop:
            value = true
        }
        return value
    }
    
    fileprivate var lazyViewControllersCount: Int {
        return isInfinity ? 5 : controllers.count
    }
    
    fileprivate var pageOptions: [ParallaxPagingViewOption:Any]
    
    fileprivate(set) var isInfinity = false
    
    fileprivate(set) var orientation = UIDeviceOrientation.unknown

    var pageSpace: CGFloat {
        if let number = pageOptions[.pageSpace] as? NSNumber {
            return CGFloat(number.floatValue)
        }
        return 0.0
    }
    
    var parallaxSpace: CGFloat {
        if let number = pageOptions[.parallaxSpace] as? NSNumber {
            return CGFloat(number.floatValue)
        }
        return 0.0
    }
    
    fileprivate(set) var currentPageIndex: Int = 0
    
    var afterPageIndex: Int {
        return currentPageIndex > controllers.count - 1 ? 0 : currentPageIndex + 1
    }
    
    var beforePageIndex: Int {
        return currentPageIndex < 0 ? controllers.count - 1 : currentPageIndex - 1
    }
    
    init(viewControllers: [ParallaxViewController],option: [ParallaxPagingViewOption:Any] = [:]) {
        controllers = viewControllers
        pageOptions = option
        super.init(nibName: nil, bundle: nil)
        constructScrollView()
        constructControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let currentOrientation = UIDevice.current.orientation
        
        guard currentOrientation != orientation else {
            return
        }
        
        containerScrollView.contentSize = CGSize(width: (view.bounds.width+pageSpace)*CGFloat(lazyViewControllersCount), height: view.bounds.height)
        containerScrollView.frame = CGRect(x: -pageSpace/2, y: 0, width: view.bounds.width + pageSpace, height: view.bounds.height)
        
        relayoutViewControllers()
        
        var currentOffset: CGPoint {
            let currentViewControllerFrame = practicalFrame(for: .current)
            return CGPoint(x: currentViewControllerFrame.origin.x-pageSpace/2, y: currentViewControllerFrame.origin.y)
        }
        
        resetVisibleControllersIfNeeded()
        containerScrollView.setContentOffset(currentOffset, animated: false)
        orientation = currentOrientation
    }
    
    internal func setInfinite(_ enabled: Bool) {
        let infiniteEnabled = enabled && controllers.count > 2
        if !infiniteEnabled {
            NSLog("infinite paging needs more than three controllers")
        }
        isInfinity = infiniteEnabled
    }
    
    fileprivate func constructScrollView() {
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        containerScrollView.delegate = self
        containerScrollView.isPagingEnabled = true
        view.addSubview(containerScrollView)
    }
    
    fileprivate func constructControllers() {
        let currentViewController = controllers[currentPageIndex]
        visibleViewControllers = [currentViewController]
    }
    
    fileprivate func showViewController(_ viewController: ParallaxViewController, position: PagePosition) {
        if !isChild(viewController) {
            addChildViewController(viewController)
        }
        relayoutViewController(viewController, position: position)
        containerScrollView.addSubview(viewController.view)
        viewController.willMove(toParentViewController: self)
    }
    
    fileprivate func hideViewController(_ viewController: ParallaxViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    fileprivate func relayoutViewController(_ viewController: ParallaxViewController, position: PagePosition) {
        viewController.view.frame = frame(at: position)
    }
    
    fileprivate func relayoutViewControllers() {
        for controller in visibleViewControllers {
            if !isChild(controller) {
                continue
            }
            if isCurrent(controller){
                relayoutViewController(controller, position: .current)
            } else if isBefore(controller){
                relayoutViewController(controller, position: .before)
            } else if isAfter(controller) {
                relayoutViewController(controller, position: .after)
            }
        }
    }
    
    fileprivate func resetVisibleControllersIfNeeded() {
        guard visibleViewControllers.count < 2 || !pagingEnabled else {
            return
        }
        for controller in visibleViewControllers {
            if !isVisible(controller) || isCurrent(controller) {
                continue
            }
            hideViewController(controller)
            let _ = visibleViewControllers.index(of: controller).flatMap{ visibleViewControllers.remove(at: $0)}
        }
    }

}

// MARK: UIScrollViewDelegate

extension ParallaxPagingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isEqual(containerScrollView) else {
            return
        }
        switch scrollDirection {
        case .left:
            scrollViewDidSrollTo(.before)
        case .right:
            scrollViewDidSrollTo(.after)
        case .stop:
            scrollViewDidSrollTo(.current)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView.isEqual(containerScrollView) else {
            return
        }
        resetVisibleControllersIfNeeded()
    }
    
}

// MARK: paging manager methods

extension ParallaxPagingViewController {
    
    func scrollViewDidSrollTo(_ position: PagePosition) {
        let currentViewController = controllers[currentPageIndex]
        var nextViewController: ParallaxViewController? {
            switch position {
            case .after:
                return controllers[afterPageIndex]
            case .before:
                return controllers[beforePageIndex]
            case .current:
                return nil
            }
        }
    
        if pagingEnabled, let nextViewController = nextViewController {
            if !isVisible(nextViewController) && !isChild(nextViewController) {
                willMoveTo(nextViewController, position: position)
            } else if didEndDisplay {
                didMoveTo(currentViewController, position: position)
            }
        }
        
        var scrollRate: CGFloat {
            let rect = currentViewController.view.convert(currentViewController.view.bounds, to: containerScrollView)
            return (rect.origin.x - containerScrollView.contentOffset.x - pageSpace/2) / containerScrollView.frame.width
        }
        
    }
    
    func scrollToCurrent(from position: PagePosition) {
        if case .after = position {
            containerScrollView.contentOffset.x -= view.bounds.width + pageSpace
        } else if case .before = position {
            containerScrollView.contentOffset.x += view.bounds.width + pageSpace
        }
    }
    
    func willMoveTo(_ viewController: ParallaxViewController, position: PagePosition) {
        showViewController(viewController, position: position)
        visibleViewControllers.append(viewController)
        delegate?.parallaxPagingView(self, willMoveTo: viewController)
    }
    
    func didMoveTo(_ viewController: ParallaxViewController, position: PagePosition) {
        updateCurrentIndex(to: position)
        resetVisibleControllersIfNeeded()
        if isInfinity {
            relayoutViewController(controllers[currentPageIndex], position: .current)
            scrollToCurrent(from: position)
        }
        delegate?.parallaxPagingView(self, didMoveTo: viewController)
    }
    
    func updateCurrentIndex(to position: PagePosition) {
        if case .after = position {
            currentPageIndex = afterPageIndex
        } else if case .before = position {
            currentPageIndex = beforePageIndex
        }
    }
    
}

// MARK: methods for layout

extension ParallaxPagingViewController {
    
    func practicalFrame(for position: PagePosition) -> CGRect {
        var viewController: ParallaxViewController {
            switch position {
            case .after:
                return controllers[afterPageIndex]
            case .before:
                return controllers[beforePageIndex]
            case .current:
                return controllers[currentPageIndex]
            }
        }
        return viewController.view.convert(viewController.view.bounds, to: containerScrollView)
    }
    
    
    func frame(at position: PagePosition) -> CGRect {
        var rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let currentViewFrame = practicalFrame(for: .current)
        switch position {
        case .after:
            rect.origin.x = currentViewFrame.origin.x - pageSpace - view.bounds.width
        case .before:
            rect.origin.x = currentViewFrame.origin.x + pageSpace + view.bounds.width
        case .current:
            rect.origin.x = isInfinity ?
                containerScrollView.contentSize.width/2-view.bounds.width/2:
                containerScrollView.bounds.width+pageSpace*CGFloat(currentPageIndex)
        }
        return rect
    }
    
}

// MARK: helper methods

internal extension ParallaxPagingViewController {
    
    func isCurrent(_ viewController: ParallaxViewController) -> Bool {
        let currentViewController = controllers[currentPageIndex]
        return viewController.isEqual(currentViewController)
    }
    
    func isBefore(_ viewController: ParallaxViewController) -> Bool {
        let beforeViewController = controllers[beforePageIndex]
        return viewController.isEqual(beforeViewController)
    }
    
    func isAfter(_ viewController: ParallaxViewController) -> Bool {
        let afterViewController = controllers[afterPageIndex]
        return viewController.isEqual(afterViewController)
    }
    
    func isChild(_ viewController: ParallaxViewController) -> Bool {
        return childViewControllers.contains(viewController)
    }
    
    func isVisible(_ viewController: ParallaxViewController) -> Bool{
        return visibleViewControllers.contains(viewController)
    }
}

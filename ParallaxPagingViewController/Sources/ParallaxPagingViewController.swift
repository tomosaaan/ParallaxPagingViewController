//
//  ParllaxPagingViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

public protocol ParallaxPagingViewControllerDelegate: class {
    func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, willMoveTo viewController:ParallaxViewController)
    func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, didMoveTo viewController:ParallaxViewController)
}

open class ParallaxPagingViewController: UIViewController {
    
    public weak var delegate: ParallaxPagingViewControllerDelegate? = nil
    
    public let containerScrollView = UIScrollView()
    
    fileprivate let controllers: [ParallaxViewController]
    
    public var visibleViewControllers = [ParallaxViewController]()
    
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
                value = true
            }
        case .right:
            if frame(at: .after).origin.x-pageSpace/2 <= containerScrollView.contentOffset.x {
                value = true
            }
        case .stop:
            print("stop")
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
    
    public var pageSpace: CGFloat = 20
    
    public var parallaxSpace: CGFloat = 50
    
    fileprivate(set) var currentPageIndex: Int = 0
    
    fileprivate var afterPageIndex: Int {
        return currentPageIndex + 1 > controllers.count - 1 ? 0 : currentPageIndex + 1
    }
    
    fileprivate var beforePageIndex: Int {
        return currentPageIndex - 1 < 0 ? controllers.count - 1 : currentPageIndex - 1
    }
    
    public init(viewControllers: [ParallaxViewController],option: [ParallaxPagingViewOption:Any] = [:]) {
        controllers = viewControllers
        pageOptions = option
        super.init(nibName: nil, bundle: nil)
        setInfinite(true)
        constructScrollView()
        constructControllers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function)
        
        let currentOrientation = UIDevice.current.orientation
        
        guard currentOrientation != orientation else {
            return
        }
        
        containerScrollView.contentSize = CGSize(width: (view.bounds.width+pageSpace)*CGFloat(lazyViewControllersCount), height: view.bounds.height)
        containerScrollView.frame = CGRect(x: -pageSpace/2, y: 0, width: view.bounds.width + pageSpace, height: view.bounds.height)
        
        let currentViewController = controllers[currentPageIndex]
        relayoutViewController(currentViewController, position: .current)
        
        var currentOffset: CGPoint {
            let currentViewControllerFrame = practicalFrame(for: .current)
            return CGPoint(x: currentViewControllerFrame.origin.x-pageSpace/2, y: currentViewControllerFrame.origin.y)
        }
        
        resetVisibleControllersIfNeeded()
        containerScrollView.setContentOffset(currentOffset, animated: false)
        orientation = currentOrientation
    }
    
    public func setInfinite(_ enabled: Bool) {
        let infiniteEnabled = enabled && controllers.count > 2
        if !infiniteEnabled, !enabled {
            NSLog("infinite paging needs more than three controllers")
        }
        isInfinity = infiniteEnabled
        relayoutPageView()
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
        addChildViewController(viewController)
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
        if !isChild(viewController) {
            showViewController(viewController, position: position)
        } else {
            viewController.view.frame = frame(at: position)
        }
    }
    
    fileprivate func resetVisibleControllersIfNeeded() {
        guard visibleViewControllers.count >= 2 || pagingEnabled else {
            return
        }
        for controller in visibleViewControllers {
            if isCurrent(controller) {
                continue
            }
            hideViewController(controller)
            let _ = visibleViewControllers.index(of: controller).flatMap{ visibleViewControllers.remove(at: $0)}
        }
    }
    
    func relayoutPageView() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

}

// MARK: UIScrollViewDelegate

extension ParallaxPagingViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(containerScrollView) {
            switch scrollDirection {
            case .left:
                scrollViewDidSrollTo(.before)
            case .right:
                scrollViewDidSrollTo(.after)
            case .stop:
                scrollViewDidSrollTo(.current)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function)
        if scrollView.isEqual(containerScrollView) {
            resetVisibleControllersIfNeeded()
        }
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
        } else {
            if visibleViewControllers.count > 1 && position == .current {
                didMoveTo(currentViewController, position: position)
            }
        }
        
        var scrollRate: CGFloat {
            let rect = currentViewController.view.convert(currentViewController.view.bounds, to: containerScrollView)
            return (rect.origin.x - containerScrollView.contentOffset.x - pageSpace/2) / containerScrollView.frame.width
        }
        nextViewController?.backgroundView.parallaxAnimate(parallaxSpace, rate: scrollRate, position: position)
        currentViewController.backgroundView.parallaxAnimate(parallaxSpace, rate: scrollRate, position: .current)
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
        let controller = controllers[currentPageIndex]
        var rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        if case .before = position {
            rect.origin.x = controller.view.frame.origin.x - pageSpace - view.bounds.width
        } else if case .after = position {
            rect.origin.x = controller.view.frame.origin.x + pageSpace + view.bounds.width
        } else if case .current = position {
            rect.origin.x = isInfinity ?
                containerScrollView.contentSize.width/2 - view.bounds.width/2 :
                containerScrollView.bounds.width * CGFloat(currentPageIndex) + pageSpace/2
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

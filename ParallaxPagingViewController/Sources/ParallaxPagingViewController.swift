//
//  ParllaxPagingViewController.swift
//  ParallaxPagingViewController
//
//  Created by takahashi tomoki on 2017/07/05.
//  Copyright © 2017年 TomokiTakahashi. All rights reserved.
//

import UIKit

@objc public protocol ParallaxPagingViewControllerDelegate: class {
    @objc optional func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, willMoveTo viewController:ParallaxViewController)
    @objc optional func parallaxPagingView(_ pagingViewController: ParallaxPagingViewController, didMoveTo viewController:ParallaxViewController)
}

open class ParallaxPagingViewController: UIViewController {
    
    open weak var delegate: ParallaxPagingViewControllerDelegate?
    
    open let containerScrollView = UIScrollView()
    
    fileprivate(set) var visibleViewControllers = [ParallaxViewController]()
    
    fileprivate(set) var isInfinity = false
    
    open var pageSpace: CGFloat = 0 {
        didSet {
            validateLayoutContents()
        }
    }
    
    open var parallaxSpace: CGFloat = 0 {
        didSet {
            validateLayoutContents()
        }
    }
    
    open var currentPageIndex: Int = 0 {
        didSet {
            validateLayoutContents()
        }
    }
    
    fileprivate var controllers = [ParallaxViewController]() {
        didSet {
            validateLayoutContents()
        }
    }
    
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
            value = false
        }
        return value
    }
    
    fileprivate var lazyViewControllersCount: Int {
        return isInfinity ? 5 : controllers.count
    }
    
    fileprivate var afterPageIndex: Int {
        return currentPageIndex + 1 > controllers.count - 1 ? 0 : currentPageIndex + 1
    }
    
    fileprivate var beforePageIndex: Int {
        return currentPageIndex - 1 < 0 ? controllers.count - 1 : currentPageIndex - 1
    }
    
    public init(_ viewControllers: [ParallaxViewController] = []) {
        super.init(nibName: nil, bundle: nil)
        controllers = viewControllers
        setupScrollView()
        setupViewControllers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        containerScrollView.contentSize = CGSize(width: (view.bounds.width+pageSpace)*CGFloat(lazyViewControllersCount),
                                                 height: containerScrollView.contentSize.height)
        containerScrollView.frame = CGRect(x: -pageSpace/2, y:0 , width: view.bounds.width + pageSpace, height: view.bounds.height)
        
        var currentOffset: CGPoint {
            let currentViewControllerFrame = practicalFrame(for: .current)
            return CGPoint(x: currentViewControllerFrame.origin.x-pageSpace/2, y: currentViewControllerFrame.origin.y)
        }
        
        containerScrollView.setContentOffset(currentOffset, animated: false)

        layoutVisibleViewControllers()
    }
    
    open func setInfinite(_ enabled: Bool) {
        if enabled && controllers.count < 3 {
            NSLog("infinite paging needs more than three controllers")
        }
        isInfinity = enabled && controllers.count > 2
    }
    
    open func setViewControllers(controllers: [ParallaxViewController]) {
        self.controllers = controllers
    }
    
    fileprivate func setupScrollView() {
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        containerScrollView.delegate = self
        containerScrollView.isPagingEnabled = true
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(containerScrollView)
    }
    
    fileprivate func setupViewControllers() {
        let currentViewController = controllers[currentPageIndex]
        visibleViewControllers = [currentViewController]
    }
    
    fileprivate func showViewController(_ viewController: ParallaxViewController, position: PagePosition) {
        addChildViewController(viewController)
        layoutViewController(viewController, position: position)
        containerScrollView.addSubview(viewController.view)
        viewController.willMove(toParentViewController: self)
    }
    
    fileprivate func hideViewController(_ viewController: ParallaxViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        let _ = visibleViewControllers.index(of: viewController).flatMap{ visibleViewControllers.remove(at: $0)}
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
}

// MARK: Paging manager methods

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
        
        func validateVisibleViewControllers() {
            if position == .after || position == .before {
                let previousViewController = position == .after ? controllers[beforePageIndex]: controllers[afterPageIndex]
                if isChild(previousViewController) {
                    hideViewController(previousViewController)
                }
            }
        }
        
        // for paging
        if pagingEnabled, let nextViewController = nextViewController {
            if !isChild(nextViewController) && !isVisible(nextViewController) {
                validateVisibleViewControllers()
                willMove(to: nextViewController, from: currentViewController, position: position)
            } else if didEndDisplay {
                didMove(to: nextViewController, from: currentViewController, position: position)
            }
        } else {
            if visibleViewControllers.count > 1 && position == .current {
                didMove(to: currentViewController, from: currentViewController, position: position)
            }
        }
        
        // for parallax animation
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
    
    func willMove(to viewController: ParallaxViewController?, from previousViewController: ParallaxViewController, position: PagePosition) {
        if let viewController = viewController {
            delegate?.parallaxPagingView?(self, willMoveTo: viewController)
            showViewController(viewController, position: position)
            visibleViewControllers.append(viewController)
        }
    }
    
    func didMove(to viewController: ParallaxViewController?,from previousViewController: ParallaxViewController, position: PagePosition) {
        func forceInfinite() {
            layoutViewController(controllers[currentPageIndex], position: .current)
            scrollToCurrent(from: position)
        }
        func updateCurrentIndex(_ position: PagePosition) {
            if position == .after {
                currentPageIndex = afterPageIndex
            } else if position == .before{
                currentPageIndex = beforePageIndex
            }
        }
        
        if let viewController = viewController {
            delegate?.parallaxPagingView?(self, didMoveTo: viewController)
            updateCurrentIndex(position)
            if isInfinity { forceInfinite() }
            if !viewController.isEqual(previousViewController) {
                hideViewController(previousViewController)
            } else {
                visibleViewControllers.filter{ !isCurrent($0)}.forEach{ hideViewController($0)}
            }
        }
    }
}

// MARK: methods for layout

fileprivate extension ParallaxPagingViewController {
    
    func validateLayoutContents() {
        guard controllers.count > 0 else {
            return
        }
        let currentViewController = controllers[currentPageIndex]
        visibleViewControllers = [currentViewController]
        
        if view.frame.width + pageSpace < parallaxSpace {
            parallaxSpace = view.frame.width + pageSpace
        }
    }
    
    func layoutViewController(_ viewController: ParallaxViewController, position: PagePosition) {
        if isChild(viewController) {
            viewController.view.frame = frame(at: position)
        } else {
            showViewController(viewController, position: position)
        }
    }
    
    func layoutVisibleViewControllers() {
        visibleViewControllers.forEach { controller in
            var position = PagePosition.current
            if isBefore(controller) {
                position = .before
            } else if isAfter(controller) {
                position = .after
            }
            showViewController(controller, position: position)
        }
    }
    
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

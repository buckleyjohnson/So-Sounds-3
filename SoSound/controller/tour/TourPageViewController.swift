//
//  TourPageViewController.swift
//  SoSound
//
//  Created by Dave Brown on 9/7/18.
//  Copyright © 2018 So Sound. All rights reserved.
//

import Foundation
import UIKit


class TourPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var viewWidth: CGFloat = 500
    var viewHeight: CGFloat = 350
    var pages = [UIViewController]()
//    var pageViewController: UIPageViewController;
    var pageIndex: Int = 0;

    required init?(coder aDecoder: NSCoder) {

        super.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal)
//        pageViewController = UIPageViewController()
    }

    override func viewDidLoad() {

        delegate = self
        dataSource = self

        view.layer.cornerRadius = 15.0
        view.backgroundColor = UIColor.black

//        addChild(pageViewController)
//        view.addSubview(pageViewController.view)
        // Set page view controller's view's frame to match host view's frame
        view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight);
        didMove(toParent: self)

        let storyboard: UIStoryboard = UIStoryboard(name: "Tour", bundle: nil)

        var tourViewController: TourIntroViewController

        if !MusicManager().verifyDownloadFiles() {
            tourViewController = storyboard.instantiateViewController(withIdentifier: "TourIntroViewController") as! TourIntroViewController
            let tourDownloadViewController = storyboard.instantiateViewController(withIdentifier: "TourDownloadViewController") as! TourDownloadViewController
            let tourCompleteViewController = storyboard.instantiateViewController(withIdentifier: "TourCompleteViewController") as! TourCompleteViewController
            pages.append(tourViewController)
            pages.append(tourDownloadViewController)
            pages.append(tourCompleteViewController)
            setViewControllers([tourViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        } else {
            let tourViewController = storyboard.instantiateViewController(withIdentifier: "TourCompleteViewController_Update") as! TourCompleteViewController
            setViewControllers([tourViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }


        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.frame = CGRect(x: (UIScreen.main.bounds.width - viewWidth) / 2, y: 30, width: viewWidth, height: viewHeight)
//        view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        return pages[pageIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        pageIndex += 1
        return pages[pageIndex]
    }

    func goToPage(page: Int, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {

        setViewControllers([pages[page]], direction: .forward, animated: animated, completion: completion)
    }
}

extension UIPageViewController {

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {

        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }

    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {

        if let currentViewController = viewControllers?[0] {
            if let previousPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) {
                setViewControllers([previousPage], direction: .reverse, animated: true, completion: completion)
            }
        }
    }

}


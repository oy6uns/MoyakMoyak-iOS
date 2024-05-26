//
//  BaseVC.swift
//  HARA
//
//  Created by 김담인 on 2022/12/27.
//

import UIKit
import SafariServices
import Lottie

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = view.center
        
        // 기타 옵션
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    private let loadingView: LottieAnimationView = {
        let view: LottieAnimationView = LottieAnimationView(name: "kaera_loading")
        view.loopMode = .loop
        view.animationSpeed = 0.3
        return view
    }()
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        setHaraBackGroundColor()
    }
}

// MARK: - Custom Methods
extension BaseVC {
    func hideTabbar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabbar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// 화면 터치시 키보드 내리는 메서드
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setHaraBackGroundColor() {
        /// 해라 기본 배경 색상으로 변경
        view.backgroundColor = .white
    }
    
    func openSafariVC(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        
        self.present(safariVC, animated: true)
    }
}

// MARK: - Custom Methods(화면전환)
extension BaseVC {
    
    /// 특정 탭의 루트 뷰컨으로 이동시키는 메서드
    func goToRootOfTab(index: Int) {
        tabBarController?.selectedIndex = index
        if let nav = tabBarController?.viewControllers?[index] as? UINavigationController {
            nav.popToRootViewController(animated: true)
        }
    }
}

// MARK: - Animation
extension BaseVC {
    
    func startLoadingAnimation() {
        self.view.addSubView(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 400).isActive = true

        self.loadingView.play()
    }
    
    func stopLoadingAnimation() {
        self.loadingView.stop()
        self.loadingView.removeFromSuperview()
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

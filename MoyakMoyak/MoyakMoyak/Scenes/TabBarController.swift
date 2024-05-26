//
//  ViewController.swift
//  MoyakMoyak
//
//  Created by saint on 2024/05/25.
//

import UIKit
import SnapKit
import Then

final class TabBarController: UITabBarController {

    // MARK: Properties
    private let backgroundView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "tab_background_img")
    }
    
    private var tagNumber: Int = 0
    private var customLabels = [UILabel]()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setTabBar()
        setTabBarUI()
        UIFont.printAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setTabBarHeight()
        addCustomLabelsToTabBarItems()
    }
    
    // MARK: - Function
    /// TabBarItem 생성해 주는 메서드
    private func makeTabVC(vc: UIViewController, tabBarTitle: String, tabBarImg: String, tabBarSelectedImg: String) -> UIViewController {
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(named: tabBarImg)?.withRenderingMode(.alwaysOriginal),
                                     selectedImage: UIImage(named: tabBarSelectedImg)?.withRenderingMode(.alwaysOriginal))
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        return vc
    }
    
    /// 각 탭바 아이템에 커스텀 레이블을 추가
    private func addCustomLabelsToTabBarItems() {
        guard let items = tabBar.items else { return }
        
        let titles = ["알약 정보", "", "알약 도우미"]
        for (index, item) in items.enumerated() {
            if let tabBarItemView = item.value(forKey: "view") as? UIView {
                let label = UILabel()
                label.text = titles[index]
                label.font = UIFont(name: "UhBeemysen", size: 16) ?? UIFont.systemFont(ofSize: 16)
                label.textColor = .black
                label.textAlignment = .center
                
                tabBarItemView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: tabBarItemView.centerXAnchor),
                    label.bottomAnchor.constraint(equalTo: tabBarItemView.bottomAnchor, constant: 0)
                ])
                customLabels.append(label)
            }
        }
        updateTabBarItemFonts(selectedIndex: self.selectedIndex)
    }

    private func updateTabBarItemFonts(selectedIndex: Int) {
        for (index, label) in customLabels.enumerated() {
            if index == selectedIndex {
                label.font = UIFont(name: "UhBeeZZIBA-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
                label.textColor = 0x454545.color
            } else {
                label.font = UIFont(name: "UhBeeZZIBA-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
                label.textColor = 0x909090.color
            }
        }
    }

    /// TabBarItem을 지정하는 메서드
    private func setTabBar() {
        let pillListTab = makeTabVC(vc: BaseNC(rootViewController: PillListVC()), tabBarTitle: "알약 정보", tabBarImg:"pill", tabBarSelectedImg: "pill_selected")
        pillListTab.tabBarItem.tag = 0

        let picTab = makeTabVC(vc: BaseNC(rootViewController: PicVC()), tabBarTitle: "", tabBarImg: "camera_btn", tabBarSelectedImg: "camera_btn")
        picTab.tabBarItem.tag = 1
        picTab.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: -8, bottom: -4, right: -8)

        let myPillTab = makeTabVC(vc: BaseNC(rootViewController: ChatBotVC()), tabBarTitle: "알약 도우미", tabBarImg: "search", tabBarSelectedImg: "search_selected")
        myPillTab.tabBarItem.tag = 2

        let tabs = [pillListTab, picTab, myPillTab]
        self.setViewControllers(tabs, animated: false)
    }

    /// TabBar의 UI를 지정하는 메서드
    private func setTabBarUI() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        appearance.backgroundImage = nil
        appearance.backgroundEffect = nil

        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        }
        
        self.backgroundView.addShadow(location: .top)
        self.view.addSubviews([backgroundView])
        self.view.bringSubviewToFront(self.tabBar)
    }

    /// TabBar의 height을 설정하는 메서드
    private func setTabBarHeight() {
        let height = self.view.safeAreaInsets.bottom + 72.adjustedH
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        backgroundView.frame = tabBar.frame
    }
    
    @objc
    private func pushToNewAccount() {
        let na = PicVC()
        self.navigationController?.pushViewController(na, animated: true)
    }
}

// MARK: - UITabBarControllerDelegate
/// 선택된 탭바의 Index를 tagNumber 변수에 저장하여 +버튼을 누르더라도 rootViewController가 변함이 없게끔 해줌
extension TabBarController: UITabBarControllerDelegate {
    private func setDelegate() {
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 1 {
            let picVC = PicVC()
            picVC.modalPresentationStyle = .overFullScreen
            self.present(picVC, animated: true, completion:nil)
            if tagNumber == 0 {
                self.selectedIndex = 0
            }
            else if tagNumber == 2 {
                self.selectedIndex = 2
            }
        } else {
            tagNumber = viewController.tabBarItem.tag
        }
        updateTabBarItemFonts(selectedIndex: tabBarController.selectedIndex)
    }
}

extension UITabBar {
    /// 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있음
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}



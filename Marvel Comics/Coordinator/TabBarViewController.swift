//
//  TabBarViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    var helper = Helper()

    override func viewDidLoad() {
        super.viewDidLoad()

        startObserving(&UserInterfaceStyleManager.shared)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

    }

    @objc func applicationDidBecomeActive() {

        helper.updateThemeState(themeChoice: helper.currentTheme())


    }

}

//
//  UserInterfaceStyleObserver.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation
import UIKit

protocol UserInterfaceStyleObserver: AnyObject {
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager)
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle)
}


extension UITableViewController: UserInterfaceStyleObserver {
    
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view controller as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view controller to desired style when start observing
        overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
    }
    
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIViewController
        overrideUserInterfaceStyle = style
        
        // Update status bar style
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension UINavigationController: UserInterfaceStyleObserver {
    
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view controller as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view controller to desire style when start observing
        overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
    }
    
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIViewController
        overrideUserInterfaceStyle = style
        
        // Update status bar style
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension UITabBarController: UserInterfaceStyleObserver {
    
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view controller as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view controller to desire style when start observing
        overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
    }
    
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIViewController
        overrideUserInterfaceStyle = style
        
        // Update status bar style
        setNeedsStatusBarAppearanceUpdate()
    }
}


extension UIView: UserInterfaceStyleObserver {
    
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view to desire style when start observing
        overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
    }
    
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIView
        overrideUserInterfaceStyle = style
    }
}


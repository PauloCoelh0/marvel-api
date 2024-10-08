//
//  Helper.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation
import AVFoundation
import UIKit

struct Helper {
    
    let defaults = UserDefaults.standard

    func currentTheme() -> Theme {
        
        let rawValue = defaults.string(forKey: "ThemeStateEnum") ?? "system"
        
        let currentTheme = Theme(rawValue: rawValue)
        
        return currentTheme!
    }
    
    func updateThemeState(themeChoice: Theme) {
        
        switch themeChoice {
            
        case .system:
            
            // Check the current system mode and change to it app wide
            
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                
                UserInterfaceStyleManager.shared.updateUserInterfaceStyle(true)
                
            } else {
                
                UserInterfaceStyleManager.shared.updateUserInterfaceStyle(false)
                
            }
            
        case .light:
            
            UserInterfaceStyleManager.shared.updateUserInterfaceStyle(false)
            
        case .dark:
            
            
            UserInterfaceStyleManager.shared.updateUserInterfaceStyle(true)
        case .daySensor:
            let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
            if let ambientLightSensor = device.devices.first(where: { $0.hasTorch && $0.isTorchAvailable }) {
                do {
                    try ambientLightSensor.lockForConfiguration()
                    let exposureTargetBias = ambientLightSensor.exposureTargetBias
                    ambientLightSensor.unlockForConfiguration()
                    if exposureTargetBias > -2.0 {
                        UserInterfaceStyleManager.shared.updateUserInterfaceStyle(false)
                    } else {
                        UserInterfaceStyleManager.shared.updateUserInterfaceStyle(true)
                    }
                } catch {
                    // handle error
                }
            } else {
                // handle error - ambient light sensor not available
            }
        }
        
        defaults.set(themeChoice.rawValue, forKey: "ThemeStateEnum")
        
     }
}

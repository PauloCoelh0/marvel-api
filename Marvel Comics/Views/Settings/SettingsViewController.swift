//
//  SettingsViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

enum Theme:String {
    
    case system
    case light
    case dark
}

protocol SettingsViewProtocol: AnyObject {
//    func show(_ viewModel: CharacterRepresentableViewModel)
}

class SettingsViewController: UIViewController {
    
    private let presenter: SettingsPresenterProtocol
    
    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SettingsViewController", bundle: Bundle(for: SettingsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

        var helper = Helper()
        
        let defaults = UserDefaults.standard
        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Set the correct setting in the UI when starting
            
            let rawValue = defaults.string(forKey: "ThemeStateEnum") ?? "system"
            
            let currentTheme = Theme(rawValue: rawValue)
            
            switch currentTheme {
                
            case .system:
                
                themeChoice.selectedSegmentIndex = 0
                
            case .light:
                
                themeChoice.selectedSegmentIndex = 1
                
            case .dark:
                
                themeChoice.selectedSegmentIndex = 2
            
            default:
                
                break
            }
            
        }
        
        @IBOutlet weak var themeChoice: UISegmentedControl!
        
        @IBAction func themeChoiceDidChange(_ sender: UISegmentedControl) {
            
            switch themeChoice.selectedSegmentIndex {
                
            case 0:
                
                helper.updateThemeState(themeChoice: .system)
            
            case 1:
                
                helper.updateThemeState(themeChoice: .light)
        
            case 2:
                
                helper.updateThemeState(themeChoice: .dark)

            default:
                break
            }
            
        }
    }

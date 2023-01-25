//
//  SettingsViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit
import AVFoundation
import MapKit

enum Theme:String {
    
    case system
    case light
    case dark
    case daySensor
}

protocol SettingsViewProtocol: AnyObject {
//    func show(_ viewModel: CharacterRepresentableViewModel)
}

class SettingsViewController: UIViewController {
    
    private let presenter: SettingsPresenterProtocol
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var buttonClicked: UISwitch!
    
    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SettingsViewController", bundle: Bundle(for: SettingsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var device: AVCaptureDevice.DiscoverySession!
    var helper = Helper()
    
    let defaults = UserDefaults.standard
    
   
    
    @IBAction func buttonClicked(_ sender: UISwitch) {
            mapView.isHidden = !mapView.isHidden
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isHidden = true
      
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
            case .daySensor:
                themeChoice.selectedSegmentIndex = 3
            default:
                break
        }
        device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                // access granted, you can now configure the sensor
                self?.configureAmbientLightSensor()
            } else {
                // access denied, show an alert to the user
                let alert = UIAlertController(title: "Error", message: "Failed to grant permission for the ambient light sensor", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

    private func configureAmbientLightSensor() {
        if let ambientLightSensor = device.devices.first(where: { $0.hasTorch && $0.isTorchAvailable }) {
            do {
                try ambientLightSensor.lockForConfiguration()
                ambientLightSensor.exposureMode = .continuousAutoExposure
                ambientLightSensor.unlockForConfiguration()
            } catch {
                let alert = UIAlertController(title: "Error", message: "Failed to configure ambient light sensor: \(error)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Ambient light sensor not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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

        case 3:
            if let ambientLightSensor = device.devices.first(where: { $0.hasTorch && $0.isTorchAvailable }) {
                do {
                    try ambientLightSensor.lockForConfiguration()
                    if ambientLightSensor.exposureTargetBias > -2.0 {
                        helper.updateThemeState(themeChoice: .light)
                    } else {
                        helper.updateThemeState(themeChoice: .dark)
                    }
                    ambientLightSensor.unlockForConfiguration()
                } catch {
                    // Show an error message to the user
                    let alert = UIAlertController(title: "Error", message: "Failed to configure ambient light sensor: \(error)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }

        default:
            break
        }
    }
}

//
//  SettingsViewController.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation
import UserNotifications

enum Theme:String {
    
    case system
    case light
    case dark
    case daySensor
}

protocol SettingsViewProtocol: AnyObject {
//    func show(_ viewModel: CharacterRepresentableViewModel)
}

class SettingsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UNUserNotificationCenterDelegate {
    
    private let presenter: SettingsPresenterProtocol
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var buttonClicked: UISwitch!
    
    @IBOutlet weak var notificationTester: UIButton!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    let locationManager = CLLocationManager()
    var annotation: MKPointAnnotation?
    
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
    
    @IBAction func notificationTester(_ sender: UIButton) {
        let switchState = defaults.bool(forKey: "notificationSwitchState")
        if switchState {
            let content = UNMutableNotificationContent()
            content.title = "Marvel Comics"
            content.body = "Hello Professor, this is a test notification."
            content.sound = UNNotificationSound.default
            content.badge = 1

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "test_notification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
                else {
                    print("Notification scheduled successfully")
                }
            }
        }
    }

    // Clear badge when user taps on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["test_notification"])
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "notificationSwitchState")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        mapView.isHidden = true
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        addLocations()
        
        let switchState = defaults.bool(forKey: "notificationSwitchState")
        notificationSwitch.isOn = switchState
        
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }

        
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
    
    func addLocations() {
        let marvelLocation = CLLocationCoordinate2D(latitude: 33.901537, longitude: -118.383948)

        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = marvelLocation
        annotation1.title = "Marvel Comics Headquarters"
        mapView.addAnnotation(annotation1)

        var zoomRect = MKMapRect.null
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: false)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            annotation = MKPointAnnotation()
            annotation?.coordinate = location.coordinate
            mapView.addAnnotation(annotation!)
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = locationManager.location?.coordinate
        if let center = center {
            if mapView.region.span.latitudeDelta > 100 {
                mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
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


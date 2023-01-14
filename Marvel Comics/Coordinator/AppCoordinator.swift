//
//  AppCoordinator.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation
import UIKit
import CoreData

protocol Coordinator {
    var rootViewController: UIViewController { get set }
    func start() -> UIViewController
}

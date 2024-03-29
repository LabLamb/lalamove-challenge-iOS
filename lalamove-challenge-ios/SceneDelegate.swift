//
//  SceneDelegate.swift
//  lalamove-challenge-ios
//
//  Created by LabLamb on 17/6/2020.
//  Copyright © 2020 LabLamb. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil { // Run app normally
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            window = UIWindow()
            window?.windowScene = windowScene
            window?.makeKeyAndVisible()
            
            let deliverMasterVC = DeliveryMasterConfigurator().configViewController()
            
            window?.rootViewController = UINavigationController(rootViewController: deliverMasterVC)
        }
    }
}


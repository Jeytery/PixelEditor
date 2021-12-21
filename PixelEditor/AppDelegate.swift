//
//  AppDelegate.swift
//  PixelEditor
//
//  Created by BarsO_o on 14.12.2021.
//

import UIKit
import Firebase
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = ArtsViewController()
        let nc = UINavigationController(rootViewController: vc)

        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        return true
    }
}

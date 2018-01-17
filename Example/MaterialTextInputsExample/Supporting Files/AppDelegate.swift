//
//  AppDelegate.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 27.10.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        
        return true
    }
    
}


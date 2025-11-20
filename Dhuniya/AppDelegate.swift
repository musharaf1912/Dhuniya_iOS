//
//  AppDelegate.swift
//  Dhuniya
//
//  Created by Lifeboat on 20/11/25.
//
import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Firebase Environment Loader
    func configureFirebase() {

        #if DEV
        print("🔥 Using DEV Firebase")

        // Load DEV GoogleService plist manually
        let filePath = Bundle.main.path(
            forResource: "GoogleService-Info-Dev",
            ofType: "plist"
        )!

        let options = FirebaseOptions(contentsOfFile: filePath)!
        FirebaseApp.configure(options: options)

        #else
        print("🔥 Using PROD Firebase")

        // Load default GoogleService-Info.plist for PROD
        FirebaseApp.configure()
        #endif
    }

    // MARK: - Application Launch
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        configureFirebase()  // 🔥 Initialize Firebase

        return true
    }
}

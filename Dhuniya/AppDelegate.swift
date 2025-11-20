//
//  AppDelegate.swift
//  Dhuniya
//
//  Created by Lifeboat on 20/11/25.
//
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func configureFirebase() {

        #if DEV
        print("🔥 Using DEV Firebase")

        let filePath = Bundle.main.path(
            forResource: "GoogleService-Info-Dev",
            ofType: "plist"
        )!

        let options = FirebaseOptions(contentsOfFile: filePath)!
        FirebaseApp.configure(options: options)

        #else
        print("🔥 Using PROD Firebase")

        FirebaseApp.configure()
        #endif
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        configureFirebase()

        // 🔥 Ask permission for push notifications
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            print("📲 Notification permission granted: \(granted)")
        }

        // 🔥 Register for APNs
        application.registerForRemoteNotifications()

        // 🔥 FCM delegate
        Messaging.messaging().delegate = self

        return true
    }


    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        print("📡 APNs device token received: \(deviceToken)")

        // Send APNs token to Firebase
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 FCM Token: \(fcmToken ?? "")")
    }

    // Display notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.banner, .sound, .badge])
    }
}

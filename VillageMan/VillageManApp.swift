//
//  VillageManApp.swift
//  VillageMan
//
//  Created by cauca on 11/5/21.
//

import SwiftUI
import Firebase

@main
struct VillageManApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { acepted, error in
            if let error = error {
                debugPrint(error)
            }
            debugPrint(acepted)
        }
        Messaging.messaging().token { token, _ in
            guard let token = token else {
                return
            }
            debugPrint("Messaging token \(token)")
        }
        application.registerForRemoteNotifications()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .badge])
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

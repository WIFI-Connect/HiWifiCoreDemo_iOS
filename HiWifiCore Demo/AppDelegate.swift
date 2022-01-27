//
//  AppDelegate.swift
//  HiWifiCore Demo
//
//  Created by Big Boss on 25.01.22.
//

import UIKit
import HiWifiCore
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, HiWifiLocationListener {

    var hiwifiService: HiWifiService = HiWifiService(locationManager: CLLocationManager())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DispatchQueue.main.async {
            self.setupHiWifiService()
        }
        return true
    }

    func setupHiWifiService() {
        NotificationCenter.default.post(name: Notification.Name("UpdateHiWifiCoreStatus"), object: self.hiwifiService, userInfo: ["Status":"setup..."])
        self.hiwifiService.setup() { status in
            if status == .successful {
                NotificationCenter.default.post(name: Notification.Name("UpdateHiWifiCoreStatus"), object: self.hiwifiService, userInfo: ["Status":"Requesting push authorization..."])
                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                UNUserNotificationCenter.current().requestAuthorization(options: options) {
                    (didAllow, error) in
                    if !didAllow {
                        print("User declined notifications!")
                        NotificationCenter.default.post(name: Notification.Name("UpdateHiWifiCoreStatus"), object: self.hiwifiService, userInfo: ["Status":"User declined notifications!"])
                    } else {
                        DispatchQueue.main.async {
                            UNUserNotificationCenter.current().delegate = self
                            self.hiwifiService.requestLocationUpdates(self)
                            NotificationCenter.default.post(name: Notification.Name("UpdateHiWifiCoreStatus"), object: self.hiwifiService, userInfo: ["Status":"Running"])
                        }
                    }
                }
            } else {
                print("HiWifi Core setup failed with status: \(status)")
                var statusText = ""
                switch status {
                case .configurationMissingOrIncorrect:
                    statusText = "Configuration missing or incorrect!"
                case .errorLoadingSSIDs:
                    statusText = "Error loading SSIDs!"
                case .locationAuthorizationMissing:
                    statusText = "Location authorization always missing!"
                default:
                    statusText = "Unknown error!"
                }
                NotificationCenter.default.post(name: Notification.Name("UpdateHiWifiCoreStatus"), object: self.hiwifiService, userInfo: ["Status":statusText])
            }
        }
    }


    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
    {
        print("app notification foreground callback")
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let targetInfo: String = response.notification.request.content.categoryIdentifier
        if(targetInfo.starts(with: "hiwifi")) {
            hiwifiService.onReceive(notification: response.notification)
        }
        completionHandler()
    }

    
    // MARK: - HiWifiLocationListener

    func onUpdate(location: HiWifiLocation?, error: HiWifiError?) {
        print("onUpdate:\(String(describing: location)) error:\(String(describing: error))")
    }

    
    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


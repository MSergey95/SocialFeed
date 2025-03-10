//
//  AppDelegate.swift
//  SocialFeed
//
//  Created by Сергей Минеев on 3/7/25.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // iOS 12-: var window: UIWindow?  // если нужно
    // Для iOS 13+ обычно не используется

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Дополнительная инициализация приложения (если нужна)
        return true
    }

    // MARK: UISceneSession Lifecycle (для iOS 13+)
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Необязательно, если у вас нет особых действий при удалении сцены
    }
}

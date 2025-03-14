//
//  AppDelegate.swift
//  SocialFeed
//
//  Created by Сергей Минеев on 3/7/25.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: PostListViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

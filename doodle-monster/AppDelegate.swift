//
//  AppDelegate.swift
//  doodle-monster
//
//  Created by Josh Freed on 9/9/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit
import FacebookCore
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var viewModelFactory: ViewModelFactory!
    var session: DoodMonSession!
    var doodleMonsterApp: DoodleMonster!
    var api: DoodMonApi!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let apiUrl = "https://doodle-monster.herokuapp.com"
//        let apiUrl = "http://localhost:8000"

        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if ProcessInfo.processInfo.arguments.contains("TESTING") {
            prepareTestData()
        } else {
            session = Session()
            api = ApiService(baseUrl: apiUrl)
        }
        
        doodleMonsterApp = DoodleMonsterApp(api: api, session: session)
        viewModelFactory = ViewModelFactory(appDelegate: self)

        session.resume()
        
        if session.hasSession() {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuViewController
            guard let _ = session.me else {
                fatalError("Have a session but can't get the current player. What's going on?")
            }
            let nc = window?.rootViewController as! UINavigationController
            nc.pushViewController(vc, animated: false)
        }
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "header"), for: .default)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }
    
    fileprivate func prepareTestData() {
        print("Put the app in testing mode")
        
        session = InMemorySession()
        let mockSession = session as! InMemorySession
        
        api = InMemoryApiService(session: mockSession)
        let mockApi = api as! InMemoryApiService
        
        let json1 = [
            "id": "11111",
            "email": "jeffery@bleepsmazz.com",
            "displayName": "Jeffery"
        ]
        var player1 = Mapper<Player>().map(JSON: json1)!
        player1.password = "bleep"
        mockApi.players.append(player1)
        
        let json2 = [
            "id": "22222",
            "email": "jerry@bleepsmazz.com",
            "displayName": "Jerry"
        ]
        var player2 = Mapper<Player>().map(JSON: json2)!
        player2.password = "bleep"
        mockApi.players.append(player2)
        
        print(ProcessInfo.processInfo.environment["CURRENT_USER"])
        if let currentPlayerId = ProcessInfo.processInfo.environment["CURRENT_USER"] {
            for player in mockApi.players {
                if player.id == currentPlayerId {
                    print("Logging in as player \(player)")
                    mockSession.me = player
                }
            }
        }
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum UserError: Error {
    case noData
}

enum DoodMonError: Error {
    case httpError(code: String, message: String)
    case serverError(message: String)
    case unexpectedResponse
    case unknownResponse
    case noToken
}

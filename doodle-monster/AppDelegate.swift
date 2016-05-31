//
//  AppDelegate.swift
//  doodle-monster
//
//  Created by Josh Freed on 9/9/15.
//  Copyright © 2015 BleepSmazz. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var viewModelFactory: ViewModelFactory!
    var playerService: PlayerService!
    var gameService: GameService!
    var session: SessionService!
    var doodleMonsterApp: DoodleMonster!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        let apiUrl = "https://doodle-monster.herokuapp.com"
        let apiUrl = "http://localhost:8080"
        
        if NSProcessInfo.processInfo().arguments.contains("TESTING") {
            prepareTestData()
        } else {
//            Parse.setApplicationId("w2AR93Gv7UL9rXlbhIC9QCm2atKflpamAfHfy26O", clientKey: "qRj7xlR7m0Pu3ls5HXcXIqMWkA9283Xrxs1TCFzs")
//            PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
//            playerService = ParseUserService()
//            session = ParseSessionService()
//            gameService = ParseGameService(parsePlayerService: playerService as! ParseUserService)
            
            session = RestSessionService(apiUrl: apiUrl)
            playerService = RestPlayerService(apiUrl: apiUrl, session: session, playerTranslator: ParsePlayerTranslator())
            gameService = RestGameService(apiUrl: apiUrl, session: session, gameTranslator: RestGameTranslator())

        }
        
        doodleMonsterApp = DoodleMonsterApp(gameService: gameService, session: session)
        
        viewModelFactory = ViewModelFactory(appDelegate: self)

        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "header"), forBarMetrics: .Default)
        
        session.resume()
        
        if session.hasSession() {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = storyboard.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuViewController
            guard let _ = session.currentPlayer else {
                fatalError("Have a session but can't get the current player. What's going on?")
            }
            vc.viewModel = viewModelFactory.mainMenuViewModel(vc)
            let nc = window?.rootViewController as! UINavigationController
            nc.pushViewController(vc, animated: false)
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func prepareTestData() {
        print("Put the app in testing mode")
        PFUser.logOut()
        session = MemorySessionService()
        playerService = MemoryPlayerService(session: session as! MemorySessionService)
        gameService = MemoryGameService(session: session as! MemorySessionService)
        (session as! MemorySessionService).playerService = playerService as! MemoryPlayerService
        
        var player1 = Player()
        player1.id = "11111"
        player1.username = "jeffery@bleepsmazz.com"
        player1.password = "bleep"
        player1.displayName = "Jeffery"
        (playerService as! MemoryPlayerService).players.append(player1)
        
        var player2 = Player()
        player2.id = "22222"
        player2.username = "jerry@bleepsmazz.com"
        player2.password = "bleep"
        player2.displayName = "Jerry"
        (playerService as! MemoryPlayerService).players.append(player2)
        
        print(NSProcessInfo.processInfo().environment["CURRENT_USER"])
        if let currentPlayerId = NSProcessInfo.processInfo().environment["CURRENT_USER"] {
            for player in (playerService as! MemoryPlayerService).players {
                if player.id == currentPlayerId {
                    (session as! MemorySessionService).currentPlayer = player
                }
            }
        }
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
        get {
            return UIApplication.sharedApplication().delegate as! AppDelegate
        }
    }
}

enum Result<T> {
    case Success(T)
    case Failure(ErrorType)
}

enum UserError: ErrorType {
    case NoData
}

enum DoodMonError: ErrorType {
    case HttpError(code: String, message: String)
    case ServerError
    case UnknownResponse
}

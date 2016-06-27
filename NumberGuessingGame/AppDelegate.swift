//
//  AppDelegate.swift
//  FunctionalVC
//
//  Created by Key Hoffman on 10/27/15.
//  Copyright © 2015 Key Hoffman. All rights reserved.
//

import UIKit

struct Screen<A> {
    let run: (A -> Void) -> UIViewController
}

struct Step<A> {
    let build: (navigationController: UINavigationController, callback: A -> Void) -> UIViewController
}

extension Step {
    init(_ screen: Screen<A>) {
        build = { navCon, callback in
            let vc = screen.run(callback)
            navCon.pushViewController(vc, animated: true)
            return vc
        }
    }
    
    func run(callback: A -> Void) -> UIViewController {
        let nc = UINavigationController()
        build(navigationController: nc, callback: callback)
        return nc
    }
    
    func flatMap<B>(f: A -> Step<B>) -> Step<B> {
        return Step<B> { navigationController, callback -> UIViewController in
            self.build(navigationController: navigationController) { a in
                f(a).build(navigationController: navigationController, callback: callback)
            }
        }
    }
}

func question(text: String) -> Step<Int> {
    return Step(question(text))
}
func question(text: String) -> Screen<Int> {
    return Screen { callback in
        let qVC = MyViewController { q in
            q.view.backgroundColor = .whiteColor()
            
            let myTextLabel = UILabel()
            myTextLabel.text = text
            myTextLabel.frame = CGRectMake(50, 300, 300, 70)
            myTextLabel.numberOfLines = 0
            myTextLabel.textColor = .blackColor()
            q.view.addSubview(myTextLabel)
            
            let myTextField = UITextField()
            myTextField.delegate = q
            myTextField.placeholder = "Enter a number"
            myTextField.frame = CGRectMake(0, 0, q.navigationController?.navigationBar.frame.size.width ?? 0, 21)
            myTextField.becomeFirstResponder()
            q.navigationItem.titleView = myTextField
            q.textFieldShouldReturn(myTextField)
            
            q.onComplete = callback
        }
        return qVC
    }
}

class Game {
    let randomNumber = Int(arc4random_uniform(100))
    var numberOfGuessesLeft = 8
    var guesses: [Int] = []
    
    func turn(guess: Int) -> Step<Int> {
        numberOfGuessesLeft -= 1
        guesses.append(guess)
        
        if guess == randomNumber {
            return question("You won!")
        } else if numberOfGuessesLeft == 0 {
            return question("You lost :( -- The number was \(randomNumber)")
        } else {
            let hint = "The number was \(randomNumber > guess ? "larger" : "smaller")"
            return question("\(hint) Wrong answer -- Try again -- \(numberOfGuessesLeft) guesses left -- You have guessed \(guesses)").flatMap(turn)
        }
    }
    
    func startGame() -> UIViewController {
        return question("Guess a number between 0 and 100").flatMap(turn).run { _ in }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = Game().startGame()
        window?.makeKeyAndVisible()
        
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
    
    
}


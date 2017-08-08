//
//  AppDelegate.swift
//  TaskApplication
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var embeddedBundle: EmbeddedBundle?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        embeddedBundle = EmbeddedBundle(databaseName: "CheetahDemo", collectionName: "Tasks")
        var count = embeddedBundle?.mongoCollection.count()
        
        if (count! <= 0) {
            if let t1 = taskMgr.createTask(name: "Pick Up Brother", desc: "Or else mom will kill you", loc: "Shanghai", priority: 9) {
                taskMgr.insertTask(task: t1, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t2 = taskMgr.createTask(name: "Get Fresh Fruit", desc: "Watermelon, Canteloupe, and Bananas", loc: "Trader Joe's", priority: 3) {
                taskMgr.insertTask(task: t2, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t3 = taskMgr.createTask(name: "Finish  Biology Homework", desc: "Need to map out the human anatomy", loc: "Desk", priority: 8) {
                taskMgr.insertTask(task: t3, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t4 = taskMgr.createTask(name: "Apply for jobs", desc: "Need to polish off resume and write cover letter", loc: "Home", priority: 5) {
                taskMgr.insertTask(task: t4, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t5 = taskMgr.createTask(name: "Watch Game of Thrones", desc: "Make sure to write blog post afterwards", loc: "HBO", priority: 2) {
                taskMgr.insertTask(task: t5, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t6 = taskMgr.createTask(name: "Complement MongoDB Mobile", desc: "It is a pretty impressive project", loc: "MongoDB", priority: 100) {
                taskMgr.insertTask(task: t6, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t7 = taskMgr.createTask(name: "Name the swift driver cheetah", desc: "It is fast, sleek, and not without its spots", loc: "MongoDB", priority: 99) {
                taskMgr.insertTask(task: t7, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t8 = taskMgr.createTask(name: "Hire back all of the interns", desc: "Note to campus recruiters", loc: "Mongo", priority: 98) {
                taskMgr.insertTask(task: t8, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t9 = taskMgr.createTask(name: "Remember to take pill", desc: "Only every other day", loc: "", priority: 6) {
                taskMgr.insertTask(task: t9, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t10 = taskMgr.createTask(name: "Write thank you note to Chip", desc: "He got you that cool new backpack", loc: "Home", priority: 4) {
                taskMgr.insertTask(task: t10, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t11 = taskMgr.createTask(name: "Change the sheets", desc: "The are getting quite disgusting", loc: "Bed", priority: 5) {
                taskMgr.insertTask(task: t11, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t12 = taskMgr.createTask(name: "Finish out the internship on a good note", desc: "Dont break everything please, that would be embarrassng", loc: "New York, NY", priority: 97) {
                taskMgr.insertTask(task: t12, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t13 = taskMgr.createTask(name: "Buy new shoes", desc: "Olds ones are disgusting and dirty", loc: "Shoe store", priority: 7) {
                taskMgr.insertTask(task: t13, col: (embeddedBundle?.mongoCollection)!)
            }
            count = embeddedBundle?.mongoCollection.count()
        }
        print("NUM DOCUMENT IN COLLECTION: \(String(describing: count))")
        
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
    
}
        

//
//  AppDelegate.swift
//  TaskApplication
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db: OpaquePointer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.db = cheetah_mongoInit(collName: "tasks")
        var count = cheetah_getCollectionCount(db: self.db!)
        
        if (count <= 0) {
            if let t1 = taskMgr.addTask(name: "Pick Up Brother", desc: "Or else mom will kill you", loc: "PS 101", priority: 9) {
                cheetah_insertTask(task: t1, db: self.db!)
            }
            if let t2 = taskMgr.addTask(name: "Get Fresh Fruit", desc: "Watermelon, Canteloupe, and Bananas", loc: "Trader Joe's", priority: 3) {
                cheetah_insertTask(task: t2, db: self.db!)
            }
            if let t3 = taskMgr.addTask(name: "Finish  Biology Homework", desc: "Need to map out the human anatomy", loc: "Desk", priority: 8) {
                cheetah_insertTask(task: t3, db: self.db!)
            }
            if let t4 = taskMgr.addTask(name: "Apply for jobs", desc: "Need to polish off resume and write cover letter", loc: "Home", priority: 5) {
                cheetah_insertTask(task: t4, db: self.db!)
            }
            if let t5 = taskMgr.addTask(name: "Watch Game of Thrones", desc: "Make sure to write blog post afterwards", loc: "HBO", priority: 2) {
                cheetah_insertTask(task: t5, db: self.db!)
            }
            if let t6 = taskMgr.addTask(name: "Complement MongoDB Mobile", desc: "It is a pretty impressive project", loc: "MongoDB", priority: 100) {
                cheetah_insertTask(task: t6, db: self.db!)
            }
            if let t7 = taskMgr.addTask(name: "Name the swift driver cheetah", desc: "It is fast, sleek, and not without its spots", loc: "MongoDB", priority: 99) {
                cheetah_insertTask(task: t7, db: self.db!)
            }
            if let t8 = taskMgr.addTask(name: "Hire back all of the interns", desc: "Note to campus recruiters", loc: "Mongo", priority: 98) {
                cheetah_insertTask(task: t8, db: self.db!)
            }
            if let t9 = taskMgr.addTask(name: "Remember to take pill", desc: "Only every other day", loc: "", priority: 6) {
                cheetah_insertTask(task: t9, db: self.db!)
            }
            if let t10 = taskMgr.addTask(name: "Write thank you note to Chip", desc: "He got you that cool new backpack", loc: "Home", priority: 4) {
                cheetah_insertTask(task: t10, db: self.db!)
            }
            if let t11 = taskMgr.addTask(name: "Change the sheets", desc: "The are getting quite disgusting", loc: "Bed", priority: 5) {
                cheetah_insertTask(task: t11, db: self.db!)
            }
            if let t12 = taskMgr.addTask(name: "Finish out the internship on a good note", desc: "Dont break everything please, that would be embarrassng", loc: "New York, NY", priority: 97) {
                cheetah_insertTask(task: t12, db: self.db!)
            }
            if let t13 = taskMgr.addTask(name: "Buy new shoes", desc: "Olds ones are disgusting and dirty", loc: "Shoe store", priority: 7) {
                cheetah_insertTask(task: t13, db: self.db!)
            }
            count = cheetah_getCollectionCount(db: self.db!)
        }
        
        print("NUM DOCUMENT IN COLLECTION: \(count)")
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


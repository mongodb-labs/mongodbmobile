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
            do {
                try embeddedBundle?.mongoCollection.setGeoIndex(onField: "geo")
                print("SET THE INDEX")
            }catch {
                print("COULD NOT SET THE INDEX")
            }
            if let t1 = taskMgr.createTask(name: "Pick Up Brother", desc: "Or else mom will kill you", loc: "New York", priority: 9, lat: -73.94, long: 40.67) {
                taskMgr.insertTask(task: t1, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t2 = taskMgr.createTask(name: "Get Fresh Fruit", desc: "Watermelon, Canteloupe, and Bananas", loc: "Shanghai", priority: 3, lat: 121.47, long: 31.23) {
                taskMgr.insertTask(task: t2, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t3 = taskMgr.createTask(name: "Finish Biology Homework", desc: "Need to map out the human anatomy", loc: "Moscow", priority: 5, lat: 37.62, long: 55.75) {
                taskMgr.insertTask(task: t3, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t4 = taskMgr.createTask(name: "Apply for jobs", desc: "Need to polish off resume and write cover letter", loc: "Tokyo", priority: 12, lat: 139.77, long: 35.67) {
                taskMgr.insertTask(task: t4, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t5 = taskMgr.createTask(name: "Watch Game of Thrones", desc: "Make sure to write blog post afterwards", loc: "Mexico City", priority: 6, lat: -99.14, long: 19.43) {
                taskMgr.insertTask(task: t5, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t6 = taskMgr.createTask(name: "Complement MongoDB Mobile", desc: "It is a pretty impressive project", loc: "London", priority: 100 , lat: -0.1, long: 51.52) {
                taskMgr.insertTask(task: t6, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t7 = taskMgr.createTask(name: "Name the swift driver cheetah", desc: "It is fast, sleek, and not without its spots", loc: "Rio de Janeiro", priority:99 , lat: -43.2, long: -22.91) {
                taskMgr.insertTask(task: t7, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t8 = taskMgr.createTask(name: "Hire back all of the interns", desc: "Note to campus recruiters", loc: "Toronto", priority: 98, lat: -79.38, long: 43.65) {
                taskMgr.insertTask(task: t8, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t9 = taskMgr.createTask(name: "Remember to take pill", desc: "Only every other day", loc: "Los Angeles", priority: 6, lat: -118.41, long: 34.11) {
                taskMgr.insertTask(task: t9, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t10 = taskMgr.createTask(name: "Write thank you note to Chip", desc: "He got you that cool new backpack", loc: "Sydney", priority: 4, lat: 151.21, long: -33.87) {
                taskMgr.insertTask(task: t10, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t11 = taskMgr.createTask(name: "Change the sheets", desc: "The are getting quite disgusting", loc: "Cape Town", priority: 5, lat: 18.46, long: -33.93) {
                taskMgr.insertTask(task: t11, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t12 = taskMgr.createTask(name: "Finish out the internship on a good note", desc: "Dont break everything please, that would be embarrassing", loc: "Berlin", priority: 95, lat: 13.38, long: 52.52) {
                taskMgr.insertTask(task: t12, col: (embeddedBundle?.mongoCollection)!)
            }
            if let t13 = taskMgr.createTask(name: "Buy new shoes", desc: "Olds ones are disgusting and dirty", loc: "Chicago", priority: 9, lat: -87.68, long: 41.84) {
                taskMgr.insertTask(task: t13, col: (embeddedBundle?.mongoCollection)!)
                print(BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: t13.toDocument())))
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
        

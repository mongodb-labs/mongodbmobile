//
//  RunCommandsViewController.swift
//  TaskApplication
//
//  Created by Tyler KAye on 8/1/17.
//  Copyright © 2017 Michael Crump. All rights reserved.
//

import UIKit

class RunCommandsViewController: UIViewController {
    
    @IBOutlet weak var collStatsButton: UIButton!
    @IBOutlet weak var serverStatusButton: UIButton!
    @IBOutlet weak var countButton: UIButton!
    @IBOutlet weak var output: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        output.text = "Output: "
        output.isEditable = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showCollStats(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            let collStats = try appDelegate.embeddedBundle?.mongoCollection.stats(options: BSON.Document())
            output.text = BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: collStats!))
        }
        catch {
            print("ERROR GETTING COLL STATS")
        }
    }
    
    @IBAction func showServerStatus(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            let serverStats = try appDelegate.embeddedBundle?.mongoClient.getServerStatus()
            output.text = BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: serverStats!))
        }
        catch {
            print("ERROR GETTING COLL STATS")
        }
    }
    
    @IBAction func showCount(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let dbname = appDelegate.embeddedBundle?.mongoDB.name
            let count = appDelegate.embeddedBundle?.mongoCollection.count()
            let collName = appDelegate.embeddedBundle?.mongoCollection.name
            if let c = count, let n = collName, let d = dbname {
                output.text = "Database Name: \(d)\nCollection Name: \(n) \nCollection Count: \(c)"
            }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

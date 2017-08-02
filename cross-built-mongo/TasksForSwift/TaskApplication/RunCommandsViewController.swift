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
        let collStats = cheetah_getCollectionStats(db: appDelegate.db!)
        output.text = collStats
    }
    
    @IBAction func showServerStatus(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let serverStatus = cheetah_getServerStatus(db: appDelegate.db!)
        output.text = serverStatus
    }
    
    @IBAction func showCount(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let count = Int(cheetah_getCollectionCount(db: appDelegate.db!))
        let collName = cheetah_getCollectionName(db: appDelegate.db!)
        output.text = "Collection Name: \(collName) \nCollection Count: \(count)"
        
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

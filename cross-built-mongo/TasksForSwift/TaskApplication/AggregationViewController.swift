//
//  AggregationViewController.swift
//  TaskApplication
//
//  Created by Tyler KAye on 8/8/17.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import UIKit

class AggregationViewController: UIViewController {

    @IBOutlet weak var segContol: UISegmentedControl!
    @IBOutlet weak var output: UITextView!
    var col: Collection?
    var query = "query default"
    var code = "code default"
    var out = "output default"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.col = appDelegate.embeddedBundle?.mongoCollection

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func switchView(_ sender: Any) {
        switch segContol.selectedSegmentIndex
        {
            case 0:
                output.text = query
            case 1:
                output.text = code
            case 2:
                output.text = out
            default:
                break; 
        }
    }
    
    @IBAction func sumButtonPusshed(_ sender: Any) {
        var code = ""
        code += "let agg = Aggregation()\n\n"
        code += "let p1: BSON.Document = [ \"$group\": [ \"_id\": nil, \"total_priority\": [ \"$sum\": \"$priority\" ] ] ]\n\n"
        code += "agg.addStage(stage: p1)\n\n"
        code += "let cursor = collection.aggregate(pipeline: agg.toDocument())"
        self.code = code
        let agg = Aggregation()
        let p1: BSON.Document = [ "$group": [ "_id": nil, "total_priority": [ "$sum": "$priority" ] ] ]
        agg.addStage(stage: p1)
        do {
            let aggQuery = try agg.toDocument()
            self.query = BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: aggQuery))
            let cursor = try self.col?.aggregate(pipeline: aggQuery)
            let docs = try cursor?.all()
            var output = ""
            for d in docs! {
                output += BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: d)) + "\n"
            }
            self.out = output
            switchView(self)
            
        } catch {
            print("FAILED TO SUM")
        }
    }
    @IBAction func averageButtonPushed(_ sender: Any) {
        var code = ""
        code += "let agg = Aggregation()\n\n"
        code += "let p1: BSON.Document = [ \"$group\": [ \"_id\": nil, \"total_priority\": [ \"$avg\": \"$priority\" ] ] ]\n\n"
        code += "agg.addStage(stage: p1)\n\n"
        code += "let cursor = collection.aggregate(pipeline: agg.toDocument())"
        self.code = code
        let agg = Aggregation()
        let p1: BSON.Document = [ "$group": [ "_id": nil, "total_priority": [ "$avg": "$priority" ] ] ]
        agg.addStage(stage: p1)
        do {
            let aggQuery = try agg.toDocument()
            self.query = BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: aggQuery))
            let cursor = try self.col?.aggregate(pipeline: aggQuery)
            let docs = try cursor?.all()
            var output = ""
            for d in docs! {
                output += BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: d)) + "\n"
            }
            self.out = output
            switchView(self)
            
        } catch {
            print("FAILED TO SUM")
        }
    }
    @IBAction func custom2ButtonPushed(_ sender: Any) {
        var code = ""
        code += "let agg = Aggregation()\n\n"
        code += "let p1: BSON.Document = [ \"$match\": [\"priority\": [\"$lte\": 10 ] ] ]\n\n"
        code += "let p2: BSON.Document = [ \"$sort\": [ \"priority\": -1 ] ]\n\n"
        code += "let p3: BSON.Document = [ \"$project\": [ \"priority\": 1, \"name\": 1, \"_id\": 0 ] ]\n\n"
        code += "agg.addStage(stage: p1)\n"
        code += "agg.addStage(stage: p2)\n"
        code += "agg.addStage(stage: p3)\n\n"
        code += "let cursor = collection.aggregate(pipeline: agg.toDocument())"
        self.code = code
        
        let agg = Aggregation()
        let p1: BSON.Document = [ "$match": ["priority": ["$lte": 10 ] ] ]
        let p2: BSON.Document = [ "$sort": [ "priority": -1 ] ]
        let p3: BSON.Document = [ "$project": [ "priority": 1, "name": 1, "_id": 0 ] ]
        agg.addStage(stage: p1)
        agg.addStage(stage: p2)
        agg.addStage(stage: p3)
        
        do {
            let aggQuery = try agg.toDocument()
            self.query = BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: aggQuery))
            let cursor = try self.col?.aggregate(pipeline: aggQuery)
            let docs = try cursor?.all()
            var output = ""
            for d in docs! {
                output += BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: d)) + "\n"
            }
            self.out = output
            switchView(self)
            
        } catch {
            print("FAILED TO DOCUMENT")
        }

    }

}

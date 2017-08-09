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
        self.output.isEditable = false

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
        code += "let p1: BSON.Document = [ \n\t\"$group\": [ \n\t\t\"_id\": nil, \n\t\t\"total_priority\": [ \n\t\t\t\"$sum\": \"$priority\" \n\t\t] \n\t] \n]\n\n"
        code += "agg.addStage(stage: p1)\n\n"
        code += "let cursor = collection.aggregate(agg.toDocument())\n\n"
        code += "let docs = cursor.all()"
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
        code += "let p1: BSON.Document = [ \n\t\"$group\": [ \n\t\t\"_id\": nil, \n\t\t\"total_priority\": [ \n\t\t\t\"$avg\": \"$priority\" \n\t\t] \n\t] \n]\n\n"
        code += "agg.addStage(stage: p1)\n\n"
        code += "let cursor = collection.aggregate(agg.toDocument())\n\n"
        code += "let docs = cursor.all()"
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
        code += "let p1: BSON.Document = [ \n\t\"$match\": [\n\t\t\"priority\": [\n\t\t\t\"$lte\": 10 \n\t\t] \n\t] \n]\n\n"
        code += "let p2: BSON.Document = [ \n\t\"$sort\": [ \n\t\t\"priority\": -1 \n\t] \n]\n\n"
        code += "let p3: BSON.Document = [ \n\t\"$project\": [ \n\t\t\"priority\": 1, \n\t\t\"name\": 1, \n\t\t\"_id\": 0 \n\t] \n]\n\n"
        code += "agg.addStage(stage: p1)\n"
        code += "agg.addStage(stage: p2)\n"
        code += "agg.addStage(stage: p3)\n\n"
        code += "let cursor = collection.aggregate(agg.toDocument())\n\n"
        code += "let docs = cursor.all()"
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
    @IBAction func geoTouched(_ sender: Any) {
        var code = ""
        code += "let agg = Aggregation()\n\n"
        code += "let p1: BSON.Document = [\n\t\"$geoNear\": [ \n\t\t\"near\": [ \n\t\t\t\"type\": \"Point\", \n\t\t\t\"coordinates\": [ -73.9667, 40.78 ] \n\t\t], \n\t\t\"spherical\": true, \n\t\t\"distanceField\": \"calculated_distance\", \n\t]\n]\n\n"
        code += "let p2: BSON.Document = [ \n\t\"$project\": [ \n\t\t\"location\": 1, \n\t\t\"name\": 1, \n\t\t\"calculated_distance\": 1, \n\t\t\"geo\": 1, \n\t\t\"_id\": 0 \n\t] \n]\n\n"
        code += "agg.addStage(stage: p1)\n"
        code += "agg.addStage(stage: p2)\n\n"
        code += "let cursor = collection.aggregate(pipeline: agg.toDocument())\n\n"
        code += "let docs = cursor.all()"
        self.code = code
        
        
        let agg = Aggregation()
        let p1: BSON.Document = [
            "$geoNear": [
                "near": [ "type": "Point", "coordinates": [ -73.9667, 40.78 ] ],
                "spherical": true,
                "distanceField": "calculated_distance",
            ]
        ]
        let p2: BSON.Document = [ "$project": [ "location": 1, "name": 1, "calculated_distance": 1, "geo": 1, "_id": 0 ] ]
        agg.addStage(stage: p1)
        agg.addStage(stage: p2)
        
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
            print("FAILED GEO QUERY")
        }
    }

    @IBAction func indexesTouched(_ sender: Any) {
        var code = ""
        code += "let docs = collections.findIndexes()"
        self.code = code
        self.query = "NA"
        do {
            let docs = try self.col?.findIndexes()
            var output = ""
            for d in docs! {
                output += BSON.prettyPrintJson(uglyJsonString: BSON.toJSONString(document: d)) + "\n"
            }
            self.out = output
            switchView(self)
        } catch {
            print("FAILED TO FIND INDEXES")
        }

    }
}

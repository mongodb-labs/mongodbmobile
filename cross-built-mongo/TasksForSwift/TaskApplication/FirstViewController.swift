//
//  FirstViewController.swift
//  TaskApplication
//
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource

{
    @IBOutlet var tblTasks : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tblTasks.reloadData()
        self.title = "Task List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskMgr.tasks.removeAll()
        
        // Get all of the tasks 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cursor = cheetah_c_findDocs(appDelegate.db)
        var doc = cheetah_c_getNextDoc(cursor)
        while (doc != nil) {
            let name = String(cString: cheetah_c_getStringValueForKey(doc, "name"), encoding: .utf8)
            let description = String(cString: cheetah_c_getStringValueForKey(doc, "description"), encoding: .utf8)
            let location = String(cString: cheetah_c_getStringValueForKey(doc, "location"), encoding: .utf8)
            let priority = Int(cheetah_c_getIntValueForKey(doc, "priority"))
            let oid = cheetah_c_getOidForBsonDoc(doc)
            _ = taskMgr.addTask(name: name!, desc: description!, loc: location!, priority: priority, oid: oid)
            doc = cheetah_c_getNextDoc(cursor)
        }
        taskMgr.tasks = taskMgr.tasks.sorted(by: {$0.priority > $1.priority})
        
        let tabItems = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabItems?[0] as! UITabBarItem
        tabItem.badgeValue = String(cheetah_getCollectionCount(db: appDelegate.db!))
        
        self.tblTasks.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return taskMgr.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: TaskTableViewCell = self.tblTasks.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.nameLabel.text = taskMgr.tasks[indexPath.row].name
        cell.descLabel.text = taskMgr.tasks[indexPath.row].description
        cell.priLabel.text = String(taskMgr.tasks[indexPath.row].priority)
        cell.priLabel.layer.masksToBounds = true
        cell.priLabel.layer.cornerRadius = cell.priLabel.frame.size.width/2;
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if (editingStyle == UITableViewCellEditingStyle.delete){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            taskMgr.deleteTaskAtIndex(index: indexPath.row, db: appDelegate.db!)
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabItems?[0] as! UITabBarItem
            tabItem.badgeValue = String(cheetah_getCollectionCount(db: appDelegate.db!))
            tblTasks.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetail") {
            if let dvc = segue.destination as? DetailViewController {
                if let indexPath = tblTasks.indexPathForSelectedRow
                {
                    dvc.task = taskMgr.tasks[indexPath.row]
                }
            }
        }
    }
}




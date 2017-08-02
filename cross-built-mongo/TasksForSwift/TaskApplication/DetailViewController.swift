//
//  DetailViewController.swift
//  TaskApplication
//
//  Created by Tyler KAye on 8/1/17.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDesc: UITextField!
    @IBOutlet weak var taskLoc: UITextField!
    @IBOutlet weak var taskPri: UITextField!
    var task: Task?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if let t = task {
            taskName.text = t.name
            taskDesc.text = t.description
            taskLoc.text = t.location
            taskPri.text = String(t.priority)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateTask(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let t = task {
            t.name = taskName.text!
            t.description = taskDesc.text!
            t.location = taskLoc.text!
            if let new_pri = Int(taskPri.text!) {
                t.priority = new_pri
                cheetah_updateDocumentByOID(db: appDelegate.db!, oid: t.oid, new_doc: t.toBson())
                _ = navigationController?.popViewController(animated: true)
            }
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

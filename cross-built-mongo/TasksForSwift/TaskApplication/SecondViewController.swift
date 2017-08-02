//
//  SecondViewController.swift
//  TaskApplication
//
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtTask: UITextField!
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet var txtLoc: UITextField!
    @IBOutlet var txtPri: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Button Clicked
    @IBAction func btnAddTask(_ sender : UIButton){
        if (txtTask.text == ""){
            //Task Title is blank, do not add a record
        } else {
            //add record
            let name: String = txtTask.text!
            let description: String = txtDesc.text!
            let location: String = txtLoc.text!
            if let priority: Int = Int(txtPri.text!) {
                if let t = taskMgr.addTask(name: name, desc: description, loc: location, priority: priority) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    cheetah_insertTask(task: t, db: appDelegate.db!)
                    clearText()
                    self.view.endEditing(true)
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }
    
    func clearText() {
        txtPri.text = ""
        txtLoc.text = ""
        txtDesc.text = ""
        txtTask.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }


}


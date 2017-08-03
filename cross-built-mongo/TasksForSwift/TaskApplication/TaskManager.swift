//
//  TaskManager.swift
//  TaskApplication
//
//

import UIKit

var taskMgr: TaskManager = TaskManager()

class TaskManager: NSObject {
    var tasks = [Task]()
    
    func createTask(name: String, desc: String, loc: String, priority: Int) -> Task? {
        if let t = Task(name: name, description: desc, location: loc, priority: priority) {
            tasks.append(t)
            return t
        }
        return nil
    }
    
    func createTask(name: String, desc: String, loc: String, priority: Int, oid: BSONObjectID) -> Task? {
        if let t = Task(name: name, description: desc, location: loc, priority: priority, oid: oid) {
            tasks.append(t)
            return t
        }
        return nil
    }
    
    func createTask(doc: BSON.Document) -> Task? {
        if let t = Task(doc: doc) {
            tasks.append(t)
            return t
        }
        return nil
    }
    
    func deleteTaskAtIndex(index: Int, col: Collection) {
        let t = tasks[index]
        var doc = BSON.Document()
        doc["_id"] = .ObjectID(t.oid)
        do {
            _ = try col.remove(query: doc)
            tasks.remove(at: index)
        } catch {
            print("ERROR DELETING TASK")
        }
    }
    
    func insertTask(task: Task, col: Collection) {
        do  {
            try col.insert(document: task.toDocument())
        }
        catch {
            print ("ERROR INSERTING DOCUMENT (\(task.name)) INTO COLLECTION")
        }
    }
    
}

//
//  TaskManager.swift
//  TaskApplication
//
//

import UIKit

var taskMgr: TaskManager = TaskManager()

class TaskManager: NSObject {
    var tasks = [Task]()
    
    func addTask(name: String, desc: String, loc: String, priority: Int) -> Task? {
        if let t = Task(name: name, description: desc, location: loc, priority: priority) {
            tasks.append(t)
            return t
        }
        return nil
    }
    
    func addTask(name: String, desc: String, loc: String, priority: Int, oid: bson_oid_t) -> Task? {
        if let t = Task(name: name, description: desc, location: loc, priority: priority, oid: oid) {
            tasks.append(t)
            return t
        }
        return nil
    }
    
    func deleteTaskAtIndex(index: Int, db: OpaquePointer) {
        cheetah_deleteTask(task: tasks[index], db: db)
        tasks.remove(at: index)
    }
    
}

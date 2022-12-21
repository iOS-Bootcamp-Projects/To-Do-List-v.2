//
//  Task.swift
//  To Do List v.2
//
//  Created by Aamer Essa on 21/12/2022.
//

import Foundation

class Task: NSObject, NSCoding {
   
    
    static var key: String = "Tasks"
    static var schema: String = "theList"
    var objective: String
    var createdAt: NSDate
    // use this init for creating a new Task
    init(obj: String) {
        objective = obj
        createdAt = NSDate()
    }
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(objective, forKey: "objective")
        aCoder.encode(createdAt, forKey: "createdAt")
    }
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        objective = aDecoder.decodeObject(forKey: "objective") as! String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as! NSDate
        super.init()
    }
    // MARK: - Queries
    static func all() -> [Task] {
        var tasks = [Task]()
        let path = Database.dataFilePath(schema: "theList")
        if FileManager.default.fileExists(atPath: path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                tasks = unarchiver.decodeObject(forKey: Task.key) as! [Task]
                unarchiver.finishDecoding()
            }
        }
        return tasks
    }
    func destroy() {
        var tasksFromStorage = Task.all()
        for var i = 0; i < tasksFromStorage.count; ++i {
            if tasksFromStorage[i].createdAt == self.createdAt {
                tasksFromStorage.removeAtIndex(i)
            }
        }
        Database.save(tasksFromStorage, toSchema: Task.schema, forKey: Task.key)
    }
    func save() {
        var tasksFromStorage = Task.all()
        var exists = false
        for var i = 0; i < tasksFromStorage.count; ++i {
            if tasksFromStorage[i].createdAt == self.createdAt {
                tasksFromStorage[i] = self
                exists = true
            }
        }
        if !exists {
            tasksFromStorage.append(self)
        }
        Database.save(arrayOfObjects: tasksFromStorage, toSchema: Task.schema, forKey: Task.key)
    }
}

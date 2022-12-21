//
//  Database.swift
//  To Do List v.2
//
//  Created by Aamer Essa on 21/12/2022.
//

import Foundation

class Database {
    // get the full path to the Documents folder
    static func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    // get the full path to file of project
    static func dataFilePath(schema: String) -> String {
        return "\(Database.documentsDirectory())/\(schema)"
    }
    static func save(arrayOfObjects: [AnyObject], toSchema: String, forKey: String) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(arrayOfObjects, forKey: "\(forKey)")
        archiver.finishEncoding()
        data.write(toFile: Database.dataFilePath(schema: toSchema), atomically: true)
    }
}

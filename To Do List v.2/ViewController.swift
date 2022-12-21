//
//  ViewController.swift
//  To Do List v.2
//
//  Created by Aamer Essa on 21/12/2022.
//

import Cocoa
import CoreData
class ViewController: NSViewController {
     
    let managedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // connect to DB
    
    @IBOutlet weak var taskTextField: NSTextField!
    @IBOutlet weak var taskTable: NSTableView!
    var tasksList = [Task]()
    var selectedValue = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTable.dataSource = self
        taskTable.delegate = self
        fetchAllTasks()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func addNewTask(_ sender: NSTextField) {
        let newTask = Task(context: managedObjectContext)
        newTask.name = sender.stringValue
        do{
            try managedObjectContext.save()
            tasksList.append(newTask)
            print(tasksList)
        } catch{
            print("\(error)")
        }
            taskTable.reloadData()
            taskTextField.stringValue = ""
    }
    
    @IBAction func finishTask(_ sender: Any) {
        managedObjectContext.delete(tasksList[selectedValue])
        do{
            try managedObjectContext.save()
            tasksList.remove(at: selectedValue)
            taskTable.reloadData()
        } catch{
            print("\(error)")
        }
       
    }
    
    func fetchAllTasks() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
                do{
                    let resualt = try managedObjectContext.fetch(request)
                      tasksList = resualt as! [Task]
                } catch {
                    print("\(error)")
                }
    }
}

extension ViewController: NSTableViewDelegate,NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        tasksList.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = taskTable.makeView(withIdentifier: .cell, owner: self) as! TasksTableViewCell
        cell.taskTitle.stringValue = tasksList[row].name!
        
        return cell
    }
    func tableViewSelectionIsChanging(_ notification: Notification) {

        selectedValue = taskTable.selectedRow
    }
    
}

extension NSUserInterfaceItemIdentifier {
   static let cell = NSUserInterfaceItemIdentifier("Cell")
}

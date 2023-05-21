//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Степан Фоминцев on 21.05.2023.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var viewContext = persistentContainer.viewContext
    
    private init() {}
    
    func save(taskName: String) {
        let task = Task(context: viewContext)
        task.title = taskName

        saveContext()
    }
    
    func delete(task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    func edit(task: Task, withTitle title: String) {
        task.title = title
        saveContext()
    }
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            completion(try viewContext.fetch(fetchRequest))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }
    
}

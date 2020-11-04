//
//  CoreDataService.swift
//  TestMacOSApp
//
//  Created by Vladislav on 11/4/20.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import CoreData

typealias DatabaseServiceLoadCompletion = (Error?) -> Void
typealias PersistenStoreDescriptionAddCompletion = (NSPersistentStoreDescription, Error?) -> Void

typealias DatabaseServiceInsertClosure<T> = (T) -> Void
typealias DatabaseServiceFetchEntitiesClosure<T> = ([T]) -> Void
typealias DatabaseServiceSuccessClosure = (Bool) -> Void

class CoreDataStack {
    fileprivate var loadCompletion: PersistenStoreDescriptionAddCompletion?
    
    lazy var backgroundContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    // Managed object model
    // swiftlint:disable force_unwrapping
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: "TestMacOSApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)!
    }()
    // swiftlint:enable force_unwrapping
    
    private lazy var persistentStoreDescription: NSPersistentStoreDescription = {
        let databaseFileName = "TestMacOSApp.sqlite"
        let url = self.applicationSupportDirectoryURL.appendingPathComponent(databaseFileName)
        
        let description = NSPersistentStoreDescription(url: url)
        description.type = NSSQLiteStoreType
        description.shouldAddStoreAsynchronously = true
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        return description
    }()
    
    // PersistentStoreCoordinator
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        coordinator.addPersistentStore(with: self.persistentStoreDescription, completionHandler: { (description, error) in
            self.loadCompletion?(description, error)
        })
        return coordinator
    }()
    
    lazy var applicationSupportDirectoryURL: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationSupportDirectory = urls[urls.count - 1]
        
        if !FileManager.default.fileExists(atPath: applicationSupportDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: applicationSupportDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let exeption {
                return applicationSupportDirectory
            }
        }
        
        return applicationSupportDirectory
    }()
    
    func saveMainContext(_ closure: (() -> Void)? = nil) {
        self.mainContext.perform {
            do {
                try self.mainContext.save()
                DispatchQueue.main.async {
                    closure?()
                }
            } catch let exception {
                let nserror = exception as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveBackgroundContext(_ closure: (() -> Void)? = nil) {
        self.backgroundContext.perform {
            do {
                try self.backgroundContext.save()
                DispatchQueue.main.async {
                    closure?()
                }
            } catch let exception {
                let nserror = exception as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

class DatabaseService {
    static let shared = DatabaseService()
    var timer: Timer?
    
    private init() {}
    
    
    private(set) var isLoaded = false
    
    func load(_ completion: DatabaseServiceLoadCompletion?) {
        self.persistentContainer.loadCompletion = { (description, error) in
            if error == nil {
                self.isLoaded = true
            }
            
            completion?(error)
        }
        
        _ = persistentContainer.backgroundContext
    }
    
    lazy var persistentContainer: CoreDataStack = {
        let container = CoreDataStack()
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveMain(_ closure: (() -> Void)? = nil) {
        persistentContainer.saveMainContext(closure)
    }
    
    func saveBackground(_ closure: (() -> Void)? = nil) {
        persistentContainer.saveBackgroundContext(closure)
    }
}

// MARK: - Work with entities
extension DatabaseService {
    func entitiesFor<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext, closure: @escaping DatabaseServiceFetchEntitiesClosure<T>) {
        self.entitiesFor(type: type, context: context, withPredicate: nil, closure: closure)
    }
    
    func entitiesFor<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext,withPredicate predicate: NSPredicate?, closure: @escaping DatabaseServiceFetchEntitiesClosure<T>) {
        entitiesFor(type: type, context: context, withPredicate: predicate, andSortDescriptors: nil, closure: closure)
    }
    
    func entitiesFor<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext, withPredicate predicate: NSPredicate?, andSortDescriptors sortDescriptors: [NSSortDescriptor]?, closure: @escaping DatabaseServiceFetchEntitiesClosure<T>) {
        context.perform {
            let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: type.self))//type.fetchRequest() as! NSFetchRequest<T>
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType
            
            guard let results = try? context.fetch(fetchRequest) else {
                closure([T]())
                return
            }
            
            closure(results)
        }
    }
    
    func insertEntityFor<T: NSManagedObject>(type: T.Type, context: NSManagedObjectContext, closure: @escaping DatabaseServiceInsertClosure<T>) {
        context.perform {
            let entity = T(context: context)
            closure(entity)
        }
    }
    
    func delete(_ entities: [NSManagedObject], context: NSManagedObjectContext, closure: DatabaseServiceSuccessClosure?) {
        guard let entity = entities.first else {
            DispatchQueue.main.async {
                closure?(true)
            }
            
            return
        }
        
        delete(entity, context: context) { (_) in
            self.delete(Array(entities.dropFirst()), context: context, closure: closure)
        }
    }
    
    func delete(_ entity: NSManagedObject, context: NSManagedObjectContext, closure: DatabaseServiceSuccessClosure?) {
        if entity.managedObjectContext == context {
            context.perform {
                context.delete(entity)
                closure?(true)
            }
        } else {
            closure?(false)
        }
    }
}

//
//  CoreDataManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    // MARK: - Properties. CoreDate Stack
    var modelName: String
    var sqliteName: String
    var options: NSDictionary?
    
    var description: String {
        return "context: \(managedObjectContext)\n" + "modelName: \(modelName)" +
            //        "model: \(model.entityVersionHashesByName)\n" +
            //        "coordinator: \(coordinator)\n" +
        "storeURL: \(applicationDocumentsDirectory)\n"
        //        "store: \(store)"
    }

    var appUser: AppUser! {
        didSet {
            didSaveContext()
        }
    }

    var appSettings: AppSettings! {
        didSet {
            didSaveContext()
        }
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator     =   NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url             =   self.applicationDocumentsDirectory.appendingPathComponent(self.sqliteName + ".sqlite")
        var failureReason   =   "CoreData saved error".localized()
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict                                =   [String: AnyObject]()
            dict[NSLocalizedDescriptionKey]         =   "CoreData init error".localized() as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey]  =   failureReason as AnyObject?
            dict[NSUnderlyingErrorKey]              =   error as NSError
            let wrappedError                        =   NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator             =   self.persistentStoreCoordinator
        var managedObjectContext    =   NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()

    
    // MARK: - Class Initialization. Singleton
    static let instance     =   CoreDataManager(modelName: "OmnieCommerceUser",
                                                sqliteName: "OmnieCommerceUser",
                                                options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
    
    private init(modelName: String, sqliteName: String, options: NSDictionary? = nil) {
        self.modelName      =   modelName
        self.sqliteName     =   sqliteName
        self.options        =   options
    }
    
    
    // MARK: - Class Functions
    func entityForName(_ entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
    }
    
    func fetchedResultsController(_ entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor              =   NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors    =   [sortDescriptor]
        
        let fetchedResultsController    =   NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }

    func didSaveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
    
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func didUpdateAppUser(state: Bool) {
        appUser.isAuthorized        =   state
        
        if (!state) {
            appUser.accessToken     =   nil
            appUser.birthday        =   nil
            appUser.codeID          =   nil
            appUser.email           =   nil
            appUser.firstName       =   nil
            appUser.imagePath       =   nil
            appUser.lastName        =   nil
            appUser.password        =   nil
            appUser.appName         =   nil
        }
        
        didSaveContext()
    }
    
    // Get Entity by name
    func didLoadEntity(byName name: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            
            return (results.count == 0) ? nil : results.first as? NSManagedObject
        } catch {
            print(error)
            
            return nil
        }
    }
}

//
//  CoreDataManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import CoreData
import Foundation
import Kingfisher

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
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: self.options as! [AnyHashable: Any]?)
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
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return managedObjectContext
    }()

    
    // MARK: - Class Initialization. Singleton
    static let instance = CoreDataManager(modelName:  "OmnieCommerceUser",
                                          sqliteName: "OmnieCommerceUser",
                                          options:    [NSMigratePersistentStoresAutomaticallyOption: true,
                                                       NSInferMappingModelAutomaticallyOption: true])
    
    private init(modelName: String, sqliteName: String, options: NSDictionary? = nil) {
        self.modelName = modelName
        self.sqliteName = sqliteName
        self.options = options
    }
    
    
    // MARK: - Class Functions
    func entityForName(_ entityName: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)
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
            appUser.surName         =   nil
            appUser.password        =   nil
            appUser.appName         =   nil
            appUser.phone           =   nil
            
            // Clean Image Cache
            KingfisherManager.shared.cache.clearMemoryCache()
            KingfisherManager.shared.cache.clearDiskCache()
        }
        
        didSaveContext()
    }
    
    // Get Entity by name
    func entityDidLoad(byName name: String, andPredicateParameter parameter: Any?) -> NSManagedObject? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>!
        var predicate: NSPredicate!
        
        if (parameter == nil) {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        } else {
            switch name {
            case "NewsData", "Organization", "Service":
                let codeID = parameter as! String
                predicate = NSPredicate(format: "codeID == %@", codeID)

            case "Schedule":
                let codeID = parameter as! String
                predicate = NSPredicate(format: "organization.codeID == %@", codeID)
                
            case "Review":
                let typeValue = parameter as! String
                predicate = NSPredicate(format: "typeValue == %@", typeValue)
                
            default:
                break
            }
            
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = predicate
        }
        
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            
            return (results.count == 0) ? self.entityDidCreate(byName: name) : results.first as? NSManagedObject
        } catch {
            print(error)
            
            return nil
        }
    }
    
    func entitiesDidLoad(byName name: String, andPredicateParameter parameter: Any?) -> [NSManagedObject]? {
        var predicate: NSPredicate!
        
        switch name {
        case "NewsData":
            let isAction = parameter as! Bool
            predicate = NSPredicate(format: "isAction == \(isAction)")

        case "Organization", "Service":
            let catalog = parameter as! String
            predicate = NSPredicate(format: "catalog == %@", catalog)

        case "Schedule":
            let codeID = parameter as! String
            predicate = NSPredicate(format: "organization.codeID == %@", codeID)

        case "Discount":
            let isUserDiscount = parameter as! Bool
            predicate = NSPredicate(format: "isUserDiscount == \(isUserDiscount)")

        case "Review":
            let typeValue = parameter as! String
            predicate = NSPredicate(format: "typeValue == %@", typeValue)
            
            case "Subcategory":
            let categoryCodeID = parameter as! String
            predicate = NSPredicate(format: "category.codeID == %@", categoryCodeID)

        default:
            break
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            return try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            print(error)
            return nil
        }
    }
    
    func entityDidCreate(byName name: String) -> NSManagedObject? {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: name, into: self.managedObjectContext)
        
//        switch name {
//        case keyCategories:
//            (newEntity as! Categories).list = nil
//            
//        default:
//            break
//        }
        
//        self.didSaveContext()
        
        return newEntity
    }
    
    func entityDidRemove(byName name: String) {
        var predicate: NSPredicate!

        switch name {
        case "XXX":
            predicate = NSPredicate(format: "codeID == %@", "XXX")

        default:
            break
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try self.managedObjectContext.fetch(fetchRequest)
            
            if let entityToRemove = fetchedEntities.first {
                self.managedObjectContext.delete(entityToRemove as! NSManagedObject)
                self.didSaveContext()
            }
        } catch {
            print(error)
        }
    }
    
    func entitiesDidRemove(byName name: String, andPredicateParameter parameter: Any?) {
        var predicate: NSPredicate!
        
        switch name {
        case "NewsData":
            let isAction = parameter as! Bool
            predicate = NSPredicate(format: "isAction == \(isAction)")

        case "Organization", "Service":
            let catalog = parameter as! String
            predicate = NSPredicate(format: "catalog == %@", catalog)

        default:
            break
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try self.managedObjectContext.fetch(fetchRequest)
            
            for entity in fetchedEntities {
                self.managedObjectContext.delete(entity as! NSManagedObject)
            }

            self.didSaveContext()
        } catch {
            print(error)
        }
    }
}

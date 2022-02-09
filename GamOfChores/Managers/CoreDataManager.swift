//
//  CoreDataManager.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-02.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    let container: NSPersistentContainer
    static let shared = CoreDataManager()
    
    private let choreFetcher: NSFetchedResultsController<Chore>
    private let memberFetcher: NSFetchedResultsController<Member>
    private let familyFetcher: NSFetchedResultsController<Family>


    var chores = [Chore]()
    var familyMembers = [Member]()
    var family = Family()
    
    init() {
        container = NSPersistentContainer(name: "GOC_Model")
        container.loadPersistentStores { desc, err in
            if let err = err {
                fatalError("Coredata err \(err.localizedDescription)")
            }
            else {
                print("Coredata success!!")
            }
        }
        
        choreFetcher = NSFetchedResultsController(fetchRequest: Chore.all, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        memberFetcher = NSFetchedResultsController(fetchRequest: Member.all, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        familyFetcher = NSFetchedResultsController(fetchRequest: Family.all, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)

    }
    
    func getFamily() -> Family {
        do {
            try familyFetcher.performFetch()
            guard let coreFamilies = familyFetcher.fetchedObjects else {
                print("Returning empty!!!")
                return Family()
            }
            print("HAS FETCHED Family!!!!")
            print(coreFamilies.first?.id)
            family = coreFamilies.first ?? Family()
            
        } catch {
            print(error)
        }
        return family
    }
    
    func fetchChores() -> [Chore]{
        do {
            try choreFetcher.performFetch()
            guard let coreChores = choreFetcher.fetchedObjects else {
                print("Returning empty!!!")
                return [Chore]()
            }
            print("HAS FETCHED CHORES!!!!")
            print(coreChores.count)
            chores = coreChores
            
        } catch {
            print(error)
        }
        return chores
    }
    
    func getFamilyMembers() -> [Member]{
        do {
            try memberFetcher.performFetch()
            guard let coreMembers = memberFetcher.fetchedObjects else {
                print("Returning empty!!!")
               
                return [Member]()
            }
            print("HAS FETCHED membos!!!!")
            print(coreMembers.count)
            familyMembers = coreMembers
            
            for member in familyMembers {
                print(member.id)
                if member.id == nil {
                    member.id = UUID()
                }
               save()
            }
            
        } catch {
            print(error)
        }
        return familyMembers
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    
    
    
    
    
    
}

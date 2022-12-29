//
//  CoreDataManager.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-02.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    var container: NSPersistentContainer
    
    static let shared = CoreDataManager()
    
    private let choreFetcher: NSFetchedResultsController<Chore>
    private let memberFetcher: NSFetchedResultsController<Member>
    private let familyFetcher: NSFetchedResultsController<Family>

    var chores = [Chore]()
    var familyMembers = [Member]()
    var families = [Family]()
    
    
    init() {
        container = NSPersistentContainer(name: "GOC_Model")
        container.loadPersistentStores { desc, err in
            if let err = err {
                fatalError("Coredata err \(err.localizedDescription)")
            }
        }
        
        choreFetcher = NSFetchedResultsController(fetchRequest: Chore.all, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        memberFetcher = NSFetchedResultsController(fetchRequest: Member.all, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        familyFetcher = NSFetchedResultsController(fetchRequest: Family.all, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)

    }
    
    func addCoreFamily(){
        let newFamily = Family(context: container.viewContext)
        newFamily.familyID = UUID()
        newFamily.mail = ""
        newFamily.isConnected = false
        print("ADDING FAM: ", newFamily)
        
        save()
    }
    
    func fetchFamily() -> Bool{
        var hasFamily = false
        do {
            try familyFetcher.performFetch()
            guard let coreFamilies = familyFetcher.fetchedObjects else {
                return hasFamily
             
            }
            if coreFamilies.count == 0 {
                hasFamily = false
            }
            else {
                hasFamily = true
            }
                        
        } catch {
            print(error)
        }
        
        return hasFamily
    }
   
    
    func getFamily() -> Family{
                
        let coreFamily = familyFetcher.fetchedObjects?.first
        
        if let coreFamily = coreFamily {
            return coreFamily
        }
        else {
            let newFamilý = Family(context: container.viewContext)
            newFamilý.familyID = UUID()
            newFamilý.isConnected = false
            return newFamilý
        }
    }
    
    func getFamilies() -> [Family]{
        do {
            try familyFetcher.performFetch()
            guard let coreFams = familyFetcher.fetchedObjects else {
                return [Family]()
            }
            families = coreFams
            
        } catch {
            print(error)
        }
        return families
    }
    
    func connectFamily(firID: String, mail: String, addNew: Bool){
        var coreFam = getFamily()
                
        var coreMebers = getFamilyMembers()
        coreFam.firID = firID
        coreFam.mail = mail
        coreFam.isConnected = true
        
        print("IS CONNECTED: \(coreFam.firID)")
      
        save()
    }
    
    func disconectFamily() {
        var coreFam = getFamily()
        coreFam.isConnected = false
    }
    
    func getChores() -> [Chore]{
        do {
            try choreFetcher.performFetch()
            guard let coreChores = choreFetcher.fetchedObjects else {
                return [Chore]()
            }
            chores = coreChores
            
        } catch {
            print(error)
        }
        return chores
    }
   
    func removeChore(chore: Chore){
       container.viewContext.delete(chore)
      
        save()
    }
    
    func removeAllChores(deleteTodo: Bool) {
        var allChores = getChores()
        
        if deleteTodo {
            for chore in allChores {
                if chore.isCompleted == false {
                    removeChore(chore: chore)
                }
            }
        } else {
            for chore in allChores {
                if chore.isCompleted == true {
                    removeChore(chore: chore)
                }
            }
        }
       
    }
    
    func setMember(id: UUID, firID: String, name: String, points: Int, time: Double, choreCount: Int64) -> Member {
        var newMember = Member(context: container.viewContext)
        newMember.memberID = id
        newMember.firID = firID
        newMember.name = name
        newMember.points = Int64(points)
        newMember.time = time
        newMember.choreCount = choreCount
        
        save()
        
        return newMember
    }
    
    func getFamilyMembers() -> [Member]{
        print("Getting members!!")
        do {
            try memberFetcher.performFetch()
            guard let coreMembers = memberFetcher.fetchedObjects else {               
                return [Member]()
            }
            
            for coreMember in coreMembers {
                if familyMembers.contains(coreMember) {
                    print("FAM CONTAINS: \(coreMember.name)")
                }
                else {
                    print("APPENDING MEMBER")
                    familyMembers.append(coreMember)
                }
            }
            
            
            for member in familyMembers {
                if member.memberID == nil {
                    member.memberID = UUID()
                }
                print(member.id)
                print(member.name)
            }
            
        } catch {
            print(error)
        }
        return familyMembers
    }
    
    func removeFamMember(member: Member) {
       container.viewContext.delete(member)
      
        save()
        
    }
    
    func resetFamily(){
        for member in getFamilyMembers() {
            member.choreCount = 0
            member.points = 0
            member.time = 0
        }
        for chore in getChores() {
            
            chore.doneBy = ""
        }
        save()
    }
    
    func deleteFamily(){
        for fam in getFamilies() {
            do{
                try fam.delete()
            } catch {
                print("ERROR DELETEING")
                print(error.localizedDescription)
            }
        }
        
        for chore in getChores() {
            do{
                try chore.delete()
            } catch {
                print("ERROR DELETEING")
                print(error.localizedDescription)
            }
        }
        
        for member in getFamilyMembers() {
            do{
                try member.delete()
            } catch {
                print("ERROR DELETEING")
                print(error.localizedDescription)
            }
        }
        save()
    }
    
    func save() {
 
        print("Saving changes!!")
        
        do {
            try container.viewContext.save()
            print("Save success!!")
            
        } catch {
            print("An error occurred while saving: \(error)")
        }
    
    }
}

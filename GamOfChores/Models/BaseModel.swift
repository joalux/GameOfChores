//
//  BaseModel.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import Foundation
import CoreData

protocol BaseModel {
    static var context: NSManagedObjectContext { get }
    
    func save() throws
    func delete() throws
}

extension BaseModel where Self: NSManagedObject{
    
    static var context: NSManagedObjectContext {
        CoreDataManager.shared.container.viewContext
    }
    
    func save() throws {
        print("Saving!")
        try Self.context.save()
    }
    
    func delete() throws {
        Self.context.delete(self)
        try save()
    }
    
}

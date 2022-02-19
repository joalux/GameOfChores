//
//  Family+Extemsions.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-22.
//

import Foundation
import CoreData

extension Family: BaseModel {
    
    static var all: NSFetchRequest<Family> {
        let request = Family.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}

//
//  Chore+Extensions.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-04.
//

import Foundation
import CoreData

extension Chore: BaseModel {
    
    static var all: NSFetchRequest<Chore> {
        let request = Chore.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}

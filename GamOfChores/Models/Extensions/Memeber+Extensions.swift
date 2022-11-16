//
//  Memeber+Extensions.swift
//  GamOfChores
//
//  Created by joakim lundberg on 2022-01-20.
//

import Foundation
import CoreData

extension Member: BaseModel {
    
    static var all: NSFetchRequest<Member> {
        let request = Member.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}

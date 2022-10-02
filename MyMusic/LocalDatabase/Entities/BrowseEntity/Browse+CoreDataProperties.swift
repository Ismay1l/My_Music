//
//  Browse+CoreDataProperties.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.10.22.
//
//

import Foundation
import CoreData


extension Browse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Browse> {
        return NSFetchRequest<Browse>(entityName: "Browse")
    }

    @NSManaged public var artistTitle: String?
    @NSManaged public var albumTitle: String?
    @NSManaged public var image: String?

}

extension Browse : Identifiable {

}


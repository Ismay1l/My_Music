//
//  SearchCategory+CoreDataProperties.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.10.22.
//
//

import Foundation
import CoreData


extension SearchCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchCategory> {
        return NSFetchRequest<SearchCategory>(entityName: "SearchCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var icon: String?

}

extension SearchCategory : Identifiable {

}

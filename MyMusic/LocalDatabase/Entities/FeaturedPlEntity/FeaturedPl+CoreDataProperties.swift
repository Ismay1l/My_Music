//
//  FeaturedPl+CoreDataProperties.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.10.22.
//
//

import Foundation
import CoreData


extension FeaturedPl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeaturedPl> {
        return NSFetchRequest<FeaturedPl>(entityName: "FeaturedPl")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: String?

}

extension FeaturedPl : Identifiable {

}

//
//  ProfileEntity+CoreDataProperties.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.10.22.
//
//

import Foundation
import CoreData


extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var plan: String?

}

extension ProfileEntity : Identifiable {

}

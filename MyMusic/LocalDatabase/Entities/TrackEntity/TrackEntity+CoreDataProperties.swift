//
//  TrackEntity+CoreDataProperties.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.10.22.
//
//

import Foundation
import CoreData


extension TrackEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackEntity> {
        return NSFetchRequest<TrackEntity>(entityName: "TrackEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var image: String?

}

extension TrackEntity : Identifiable {

}

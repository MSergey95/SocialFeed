//
//  PostEntity+CoreDataProperties.swift
//  SocialFeed
//
//  Created by Сергей Минеев on 3/7/25.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}

extension PostEntity : Identifiable {

}

//
//  Favorite+CoreDataProperties.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/7/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var title: String?
    @NSManaged public var release_date: String
    @NSManaged public var score: NSNumber?
    @NSManaged public var overview: String?
    @NSManaged public var poster_img: Data?
    @NSManaged public var id: NSNumber?
    

}

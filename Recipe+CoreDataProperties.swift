//
//  Recipe+CoreDataProperties.swift
//  recipe
//
//  Created by Hadia Thaniana on 1/21/23.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var ingredient: String?
    @NSManaged public var recipe: String?
    @NSManaged public var name: String?

}

extension Recipe : Identifiable {

}

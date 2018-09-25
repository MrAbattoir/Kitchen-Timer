//
//  Item.swift
//  Kitchen Timer
//
//  Created by Kevin Meatyard on 25/09/2018.
//  Copyright © 2018 Kevin Meatyard. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var timeCook: String = ""
    var parentCatagory = LinkingObjects(fromType: Catagory.self, property: "items")
}

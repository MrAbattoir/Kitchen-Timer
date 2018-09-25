//
//  Catagory.swift
//  Kitchen Timer
//
//  Created by Kevin Meatyard on 25/09/2018.
//  Copyright © 2018 Kevin Meatyard. All rights reserved.
//

import Foundation
import RealmSwift

class Catagory: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

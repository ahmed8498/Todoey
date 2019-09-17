//
//  Category.swift
//  Todoey
//
//  Created by Ahmed Mohamed on 8/24/19.
//  Copyright © 2019 Ahmed Mohamed. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

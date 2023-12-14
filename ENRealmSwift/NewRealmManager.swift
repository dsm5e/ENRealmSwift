//
//  NewRealmManager.swift
//  ENRealmSwift
//
//  Created by dsm 5e on 14.12.2023.
//

import Foundation
import RealmSwift

//Steps to realm
//1: add realm
//2: connect realm
//3: create object
//4:
//CRUD

class NewRealmManager {
    let realm = try! Realm()
    var allItems: [ToDoItem] = []
    
    init() {
        fetchList()
    }
    
    ///Read
    func fetchList() {
        let realmItems = realm.objects(ToDoItem.self)
        self.allItems = Array(realmItems)
    }

    ///Create
    func addNewItem(item: ToDoItem) {
        try? realm.write({
            realm.add(item)
        })
        fetchList()
    }
    
    ///Delete
    func deleteItem(id: ObjectId) {
        if let item = realm.object(ofType: ToDoItem.self, forPrimaryKey: id) {
            try? realm.write({
                realm.delete(item)
            })
            fetchList()
        }
    }
}

class ToDoItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var date = Date()
    @Persisted var isActive = false
}

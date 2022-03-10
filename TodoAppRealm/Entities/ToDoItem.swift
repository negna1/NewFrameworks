//
//  ToDoItem.swift
//  TodoAppRealm
//
//  Created by Nato Egnatashvili on 02.03.22.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var text = ""
    @objc dynamic var isCompleted = false
    
    static func create(withText text: String) -> ToDoItem {
        let todo = ToDoItem()
        todo.text = text
        return todo
    }
    
    static func all(in realm: Realm = try! Realm()) -> Results<ToDoItem> {
      return realm.objects(ToDoItem.self)
    }

    @discardableResult
    static func add(text: String, in realm: Realm = try! Realm())
      -> ToDoItem {
          let item = ToDoItem.create(withText: text)
      try! realm.write {
        realm.add(item)
      }
    return item }
    
    func delete() {
      guard let realm = realm else { return }
      try! realm.write {
        realm.delete(self)
      }
    }
    
    func toogleComplete() {
      guard let realm = realm else { return }
      try! realm.write {
          self.isCompleted = !self.isCompleted
      }
    }
}


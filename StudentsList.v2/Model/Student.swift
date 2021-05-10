//
//  Student.swift
//  StudentsList.v2
//
//  Created by Ильгам Ахматдинов on 10.05.2021.
//

import CoreData

@objc(Student)
class Student: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var lastName: String!
    @NSManaged var rate: String!
    @NSManaged var deletedDate: Date?
}

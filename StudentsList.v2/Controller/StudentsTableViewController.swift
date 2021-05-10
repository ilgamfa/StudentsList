//
//  StudentsTableViewController.swift
//  StudentsList.v2
//
//  Created by Ильгам Ахматдинов on 10.05.2021.
//

import UIKit
import CoreData

var studentList = [Student]()
var selectedStudent: Student? = nil

class StudentTableViewController: UITableViewController {
    
    var firstLoad = true
    
    func nonDeletedStudents() -> [Student] {
        
        var noDeleteStudentList = [Student]()
        
        for student in studentList{
            if(student.deletedDate == nil) {
                noDeleteStudentList.append(student)
            }
        }
        return noDeleteStudentList
    }
    
    
    override func viewDidLoad() {
        if(firstLoad) {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let student = result as! Student
                    studentList.append(student)
                }
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentCell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentCell
        
        let thisStudent: Student!
        thisStudent = nonDeletedStudents()[indexPath.row]
        
        studentCell.nameTextLabel.text = thisStudent.name
        studentCell.lastNameTextLabel.text = thisStudent.lastName
        studentCell.rateLabel.text = thisStudent.rate
        
        return studentCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedStudents().count
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editStudent", sender: self)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editStudent") {
            
            let indexPath = tableView.indexPathForSelectedRow!
            
            let studentDetail = segue.destination as? StudentDetailViewController
            studentDetail?.navigationItem.title = "Edit"
            let selectedStudent: Student!
            selectedStudent = nonDeletedStudents() [indexPath.row]
            studentDetail!.selectedStudent = selectedStudent
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

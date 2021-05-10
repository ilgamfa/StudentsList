//
//  ViewController.swift
//  StudentsList.v2
//
//  Created by Ильгам Ахматдинов on 10.05.2021.
//

import UIKit
import CoreData

class StudentDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    
    var selectedStudent: Student? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (selectedStudent != nil) {
            nameTextField.text = selectedStudent?.name
            lastNameTextField.text = selectedStudent?.lastName
            rateTextField.text = selectedStudent?.rate
        }
    }

    @IBAction func saveAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if(selectedStudent == nil) {
            
            let entity = NSEntityDescription.entity(forEntityName: "Student", in: context)
            let newStudent = Student(entity: entity!, insertInto: context)
            
            newStudent.id = studentList.count as NSNumber
            newStudent.name = nameTextField.text!
            newStudent.lastName = lastNameTextField.text!
            newStudent.rate = rateTextField.text!
            
            do {
                try context.save()
                studentList.append(newStudent)
                navigationController?.popViewController(animated: true)
            } catch {
                print("context save error")
            }
        } else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let student = result as! Student
                    if(student == selectedStudent) {
                        student.name = nameTextField.text
                        student.lastName = lastNameTextField.text
                        student.rate = rateTextField.text
                        try context.save()
                        navigationController?.popViewController(animated: true )
                    }
                }
            } catch {
                print("Fetch failed")
            }
        }
        
    }
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let student = result as! Student
                if(student == selectedStudent) {
                    student.deletedDate = Date( )
                    try context.save()
                    navigationController?.popViewController(animated: true )
                }
            }
        } catch {
            print("Fetch failed")
        }
    }
}


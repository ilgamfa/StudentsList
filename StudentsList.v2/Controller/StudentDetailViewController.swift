//
//  ViewController.swift
//  StudentsList.v2
//
//  Created by Ильгам Ахматдинов on 10.05.2021.
//

import UIKit
import CoreData

class StudentDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    
    var selectedStudent: Student? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        rateTextField.delegate = self
        
        
        if (selectedStudent != nil) {
            nameTextField.text = selectedStudent?.name
            lastNameTextField.text = selectedStudent?.lastName
            rateTextField.text = selectedStudent?.rate
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        rateTextField.resignFirstResponder()
        return true
    }
    
   
    @IBAction func nameCheck(_ sender: UITextField) {
        let text = nameTextField.text ?? ""
        if text.isValidName() {
            nameTextField.textColor = .blue
        } else {
            nameTextField.textColor = .red
        }
        
    }
    
    @IBAction func lastNameCheck(_ sender: UITextField) {
        
        let text = lastNameTextField.text ?? ""
        if text.isValidName() {
            lastNameTextField.textColor  = .blue
        } else {
            lastNameTextField.textColor = .red
            
        }
    }
    
    @IBAction func rateCheck(_ sender: UITextField) {
        
        let text = rateTextField.text ?? ""
        if text.isValidRate() {
            rateTextField.textColor = .blue
            
        } else {
            
            rateTextField.textColor = .red
        }
    }
    
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        var flag = true
        
        if nameTextField.textColor == UIColor.red {
            let alert = UIAlertController(title: "Ошибка ввода Имени. В поле должны содержаться только русские или английские символы без пробелов!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Исправить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            flag = false
        }
        else if nameTextField.text == "" {
            let alert = UIAlertController(title: "Ошибка ввода Имени. Поле должно быть заполнено!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Исправить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            flag = false
        }
        else if lastNameTextField.textColor == UIColor.red {
            let alert = UIAlertController(title: "Ошибка ввода Фамилии. В поле должны содержаться только русские или английские символы без пробелов!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Исправить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            flag = false
        }
        else if lastNameTextField.text == "" {
            let alert = UIAlertController(title: "Ошибка ввода Фамилии. Поле должно быть заполнено!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Исправить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            flag = false
        }
        else if rateTextField.textColor == UIColor.red {
            let alert = UIAlertController(title: "Ошибка ввода Среднего балла. В поле должно содержаться только целое число от 1 до 5 без пробелов!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Исправить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            flag = false
        }
        else if rateTextField.text == "" {
            let alert = UIAlertController(title: "Ошибка ввода Среднего балла. Поле должно быть заполнено!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Исправить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            flag = false
        }
        
        
        
        
        if flag {
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


extension String {
    func isValidName() -> Bool {
        let inputRegEx = "[a-zA-Zа-яА-я]{2,25}"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
    
    func isValidRate() -> Bool {
        let inputRegEx = "[1-5]"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
}


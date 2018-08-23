//
//  TaskEditController.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 03.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import UIKit

class TaskEditController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        if Preferences.backgroundImageName != "None" {
            let img = UIImageView(image: UIImage(named: Preferences.backgroundImageName)!)
            img.contentMode = .scaleAspectFill
            img.frame = self.view.frame
            self.view.addSubview(img)
            self.view.sendSubviewToBack(img)
        }
        
        formatter.dateFormat = "dd.MM.YYYY hh:mm:ss"
        
        if (new) {
            nameField.text = "Task"
            dateField.text = formatter.string(from: Date())
            descriptionField.text = "Add a description of your task here..."
        }  else {
            nameField.text = task?.name
            dateField.text = task?.dueDate
            descriptionField.text = task?.description
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if Preferences.backgroundImageName == "black" || Preferences.theme == "Dark" {
            return .lightContent
            
        } else {
            return .default
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var descriptionViewContainer: UIView!
    @IBOutlet weak var reminderContainerView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var reminderField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    var new = false
    var listId = 0
    var currentList = 0
    var task : Task?
    
    func showDatePicker() {

        datePicker.datePickerMode = .dateAndTime
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        dateField.inputAccessoryView = toolbar
        reminderField.inputAccessoryView = toolbar
    }
    
    @objc func doneDatePicker(){
        if reminderField.isFirstResponder {
            reminderField.text = formatter.string(from: datePicker.date)
        } else {
            dateField.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func setUpUI() {
        
        let labels = [nameLabel, dueDateLabel, reminderLabel]
        
        for label in labels {
            label?.textColor = Preferences.textColor
        }
        
        let containers = [nameContainerView, dateContainerView, descriptionViewContainer, reminderContainerView]
    
        for view in containers {
            view!.layer.cornerRadius = 10.0
            view!.layer.shadowColor = UIColor.black.cgColor
            view!.layer.shadowOpacity = 0.15
            view!.layer.shadowOffset = CGSize(width: 0, height: 5)
            view!.layer.shadowRadius = 10
            view!.backgroundColor = Preferences.cellColor
            
            if Preferences.blur {
                let color = Preferences.cellColor.withAlphaComponent(0.6)
                view?.backgroundColor = color
                
                var blur = UIBlurEffect(style: .light)
                
                if Preferences.theme == "Dark" {
                    blur = UIBlurEffect(style: .dark)
                }
                
                let effectView = UIVisualEffectView (effect: blur)
                //effectView.frame = view!.frame
                effectView.frame = CGRect(x: (view?.frame.minX)!, y: (view?.frame.minY)!, width: (view?.frame.width)!, height: (view?.frame.height)!)
                effectView.layer.cornerRadius = 10.0
                effectView.clipsToBounds = true
                self.view.addSubview(effectView)
                self.view.sendSubviewToBack(effectView)
            }
        }
        
        let fields = [nameField, dateField, reminderField]
        
        for field in fields {
            field!.borderStyle = .roundedRect
            field!.layer.cornerRadius = 7.5
            field!.backgroundColor = /*Preferences.cellColor*/ UIColor.clear
            field!.layer.borderWidth = 2.0
            field!.layer.borderColor = Preferences.taskSeparatorColor.cgColor
            field!.layer.masksToBounds = true
            field!.textColor = Preferences.textColor
        }
        
        descriptionField.layer.cornerRadius = 7.5
        descriptionField.backgroundColor = UIColor.clear
        descriptionField.layer.borderWidth = 2.0
        descriptionField.layer.borderColor = Preferences.taskSeparatorColor.cgColor
        descriptionField.textColor = Preferences.textColor
        
        let topBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: self.view.frame.width, height: 96))
        navigationBar.prefersLargeTitles = true

        view.addSubview(topBar)
        view.addSubview(navigationBar)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTaskAction(_:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTaskAction(_:)))
        
        let navigationItem = UINavigationItem(title: "Edit Task")
        if new {
            navigationItem.title = "New Task"
        }

        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationBar.items = [navigationItem]
        
        
        if Preferences.theme == "Dark" {
            topBar.barStyle = .black
            topBar.backgroundColor = Preferences.cellColor.withAlphaComponent(0.6)
            navigationBar.barStyle = .black
            navigationBar.backgroundColor = Preferences.cellColor.withAlphaComponent(0.6)
        } else {
            topBar.barStyle = .default
            navigationBar.barStyle = .default
        }
        
    }
    
    @IBAction func dateFieldEditAction(_ sender: Any) {
        dateField.inputView = datePicker
        showDatePicker()
    }
    
    @IBAction func reminderFieldEditAction(_ sender: Any) {
        reminderField.inputView = datePicker
        showDatePicker()
    }
    
    @objc func cancelTaskAction(_ sender: Any) {
        performSegue(withIdentifier: "cancelTaskSegue", sender: nil)
    }
    
    @objc func saveTaskAction(_ sender: Any) {
        if (nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || descriptionField.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" || dateField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            
            // create the alert
            let alert = UIAlertController(title: ("Error") , message: "Please fill out all of the fields.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            if (new && listId != 0) {
                let task = Task(name: nameField.text!, description: descriptionField.text!, dueDate: dateField.text!)
                TaskerAPI.shared.newTask(task: task, listId: listId)
                performSegue(withIdentifier: "doneTaskSegue", sender: nil)
            } else if (!new && listId != 0) {
                self.task?.name = nameField.text!
                self.task?.dueDate = dateField.text!
                self.task?.description = descriptionField.text!
                TaskerAPI.shared.updateTask(task: self.task!)
                performSegue(withIdentifier: "doneTaskSegue", sender: nil)
            } else {
                print("U in trouble boy")
            }
        }
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
        let controller = segue.destination as! MainController
        controller.scrollToList = self.currentList
    }
    

}

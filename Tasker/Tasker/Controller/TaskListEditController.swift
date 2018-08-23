//
//  TaskListEditController.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 03.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import UIKit

class TaskListEditController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        //taskTableView.allowsSelectionDuringEditing = false
        taskTableView.separatorStyle = .none
        taskTableView.setEditing(true, animated: false)
        taskTableView.backgroundColor = /*Preferences.cellColor*/ UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (currentList != nil) {
            titleField.text = TaskerAPI.shared.lists[currentList!].title
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if Preferences.backgroundImageName == "black" || Preferences.theme == "Dark" {
            return .lightContent
            
        } else {
            return .default
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var taskTableContainerView: UIView!
    @IBOutlet weak var deleteContainerView: UIView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
   // let blur = UIBlurEffect(style: .light)
    let titleBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let taskTableContainerBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let deleteContainerBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    // var data = [Task]()
    var currentList : Int?
    var scrollTo : Int?
    private let kSeparatorId = 123
    private let kSeparatorHeight: CGFloat = 3
    
    func setUpUI() {
        
        //titleBlurView.frame
        
        titleLabel.textColor = Preferences.textColor
        
        let containers = [titleContainerView, taskTableContainerView, deleteContainerView]

        /*
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = titleContainerView.frame
        titleContainerView.addSubview(effectView)
 */
 
        for view in containers {
            view!.layer.cornerRadius = 10.0
            view!.layer.shadowColor = UIColor.black.cgColor
            view!.layer.shadowOpacity = 0.15
            view!.layer.shadowOffset = CGSize(width: 0, height: 5)
            view!.layer.shadowRadius = 10
            view!.backgroundColor =  /*UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6) */Preferences.cellColor
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

        /*
        if Preferences.blur {
            let color = Preferences.cellColor.withAlphaComponent(0.6)
            taskTableContainerView?.backgroundColor = color
            
            let blur = UIBlurEffect(style: .light)
            let effectView = UIVisualEffectView (effect: blur)
            //effectView.frame = view!.frame
            effectView.frame = taskTableContainerView!.bounds
            
            //taskTableContainerView.addSubview(effectView)
            taskTableContainerView!.insertSubview(effectView, at: 0)
        }*/
        
        titleField.borderStyle = .roundedRect
        titleField.layer.cornerRadius = 7.5
        titleField.backgroundColor = /*Preferences.cellColor*/ UIColor.clear
        titleField.layer.borderWidth = 2.0
        titleField.layer.borderColor = Preferences.textColor.cgColor
        titleField.layer.masksToBounds = true
        titleField.textColor = Preferences.textColor
                
        taskTableView.layer.cornerRadius = 10.0
        taskTableView.rowHeight = CGFloat(60)
        // taskTableView.setEditing(true, animated: false)
        
        if (currentList == nil) {
            deleteButton.isEnabled = false
        }
        
        let topBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 44, width: self.view.frame.width, height: 96))
        navigationBar.prefersLargeTitles = true
        
        view.addSubview(topBar)
        view.addSubview(navigationBar)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction(_:)))
        
        let navigationItem = UINavigationItem(title: "Edit Task List")
        if currentList == nil {
            navigationItem.title = "New Task List"
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
    
    @objc func cancelAction(_ sender: Any) {
        performSegue(withIdentifier: "cancelTaskListSegue", sender: nil)
    }
    
    @objc func saveAction(_ sender: Any) {
        // save tasklist object
        if (titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != nil && currentList == nil) {
            let taskList = TaskList(title: titleField.text!)
            TaskerAPI.shared.newTaskList(taskList: taskList)
            performSegue(withIdentifier: "doneTaskListSegue", sender: nil)
        } else if (titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != nil) {
            // update
            print(titleField.text!)
            TaskerAPI.shared.lists[currentList!].title = titleField.text!
            TaskerAPI.shared.updateTaskList(taskList: TaskerAPI.shared.lists[currentList!])
            performSegue(withIdentifier: "doneTaskListSegue", sender: nil)
        } else {
            // create the alert
            let alert = UIAlertController(title: ("Error") , message: "Please add a Title.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentList != nil) {
            return TaskerAPI.shared.lists[currentList!].tasks!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.nameLabel.text = TaskerAPI.shared.lists[currentList!].tasks![indexPath.row].name
        cell.dateDetailLabel.text = TaskerAPI.shared.lists[currentList!].tasks![indexPath.row].dueDate.description
        cell.completedButton.isHidden = true
        cell.completedButton.isUserInteractionEnabled = false
        cell.editButton.isHidden = true
        cell.editButton.isUserInteractionEnabled = false
  
        cell.nameLabel.textColor = Preferences.textColor
        cell.dateDetailLabel.textColor = Preferences.textColor
        cell.backgroundColor = UIColor.clear
        /*
        if Preferences.blur {
            let color = Preferences.cellColor.withAlphaComponent(0.6)
            cell.backgroundColor = color
            
            let blur = UIBlurEffect(style: .light)
            let effectView = UIVisualEffectView (effect: blur)
            effectView.frame = cell.containerView.bounds
            //cell.addSubview(effectView)
            cell.containerView.insertSubview(effectView, at: 0)
        }*/

        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //add separator only once
        if cell.viewWithTag(kSeparatorId) == nil
        {
            let separatorView = UIView(frame: CGRect(x: 10, y: cell.frame.height - kSeparatorHeight, width: cell.frame.width - 20, height: kSeparatorHeight))
            separatorView.tag = kSeparatorId
            separatorView.backgroundColor = Preferences.taskSeparatorColor
            separatorView.layer.cornerRadius = 2
            separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            cell.addSubview(separatorView)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            completionHandler(true)
        }
        delete.image = UIImage(named: "garbage")
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // remove row and task from db
            if (currentList != nil) {
                // print(TaskerAPI.shared.lists[currentList!].tasks![indexPath.row].name)
                TaskerAPI.shared.deleteTask(taskId: TaskerAPI.shared.lists[currentList!].tasks![indexPath.row].id!)
                TaskerAPI.shared.lists[currentList!].tasks!.remove(at: indexPath.row)
                taskTableView.reloadData()
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        
        TaskerAPI.shared.deleteTaskList(taskListId: TaskerAPI.shared.lists[currentList!].id!)
    }
    
    /*
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            completionHandler(true)
        }
        
        delete.image = UIImage(named: "garbage")
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
 */
    /*
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            completionHandler(true)
        }
        
        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
            let controller = segue.destination as! MainController
            controller.scrollToList = self.scrollTo!
        
    }
    

}

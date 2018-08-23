//
//  TaskListView.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 27.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation
import UIKit

class TaskListView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var data : [Task]?
    private let kSeparatorId = 123
    private let kSeparatorHeight: CGFloat = 3
    var cellDelegate : TaskCellProtocol?
    // var refreshControl = UIRefreshControl()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // tableView.backgroundColor = UIColor.lightGray
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data!.count
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.nameLabel.text = data![indexPath.row].name
        cell.dateDetailLabel.text = data![indexPath.row].dueDate.description
        cell.completedButton.tag = indexPath.row
        cell.editButton.tag = indexPath.row
        cell.completedButton.addTarget(self, action: #selector(completed), for: UIControl.Event.touchUpInside)
        cell.editButton.addTarget(self, action: #selector(edit), for: UIControl.Event.touchUpInside)
        
        
        if Preferences.theme == "Dark" {
            cell.completedButton.setImage(UIImage(named: "checkmark-white"), for: .normal)
            cell.editButton.setImage(UIImage(named: "ruler-white"), for: .normal)
        } else {
            cell.completedButton.setImage(UIImage(named: "checkmark-black"), for: .normal)
            cell.editButton.setImage(UIImage(named: "ruler-black"), for: .normal)
        }
        
        // Colors
        //cell.backgroundColor = Preferences.cellColor
        cell.backgroundColor = UIColor.clear
        cell.nameLabel.textColor = Preferences.textColor
        cell.dateDetailLabel.textColor = Preferences.textColor
        
        cell.clipsToBounds = true
        
        return cell
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
    
    @objc func completed(sender: UIButton) {
        
        self.data?.remove(at: sender.tag)
        self.tableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: UITableView.RowAnimation.fade)
        TaskerAPI.shared.deleteTask(taskId: (self.data?[sender.tag].id!)!)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()

        }
        
    }
    
    @objc func edit(sender: UIButton) {
        // perform segue to edit
        
        for list in TaskerAPI.shared.lists {
            for task in list.tasks! {
                if (task.id! == self.data?[sender.tag].id!) {
                    self.cellDelegate?.performSegueFromCell(taskId: sender.tag)
                }
            }
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
            
            self.data?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            TaskerAPI.shared.deleteTask(taskId: (self.data?[indexPath.row].id!)!)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        // self.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 2.5) // CGSize.zero
        self.layer.shadowRadius = 10
/*
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull down to reload")
        self..refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
 */
        /*
        UIGraphicsBeginImageContext(self.frame.size)
        UIImage(named: "Dodger Blue")?.draw(in: self.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        */
        
        tableView.backgroundColor = UIColor.clear

        tableView.layer.cornerRadius = 10.0
        tableView.separatorStyle = .none
        tableView.rowHeight = CGFloat(75)
        /*tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
 */
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        /* Constraints
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        */
        
        self.addSubview(tableView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

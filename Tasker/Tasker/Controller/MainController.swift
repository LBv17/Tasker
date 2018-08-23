//
//  MainController.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 27.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import UIKit

class MainController: UIViewController, UIScrollViewDelegate, TaskCellProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Preferences.isAppAlreadyLaunchedOnce() {
            Preferences.loadPreferences()
        } else {
            Preferences.savePreferences()
        }
        
        if Preferences.backgroundImageName != "None" {
            let img = UIImageView(image: UIImage(named: Preferences.backgroundImageName)!)
            img.contentMode = .scaleAspectFill
            img.frame = self.view.frame
            self.view.addSubview(img)
            self.view.sendSubviewToBack(img)
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: Preferences.backgroundImageName)!)
        }
        /*
        TaskerAPI.shared.getAll() { lists, error  in
            if error != nil {
                print(error!)
            } else {
                
            }
            /*
            TaskerAPI.shared.lists = lists!
            DispatchQueue.main.async {
                // print(TaskerAPI.shared.lists)
                self.setUpScrollView()
            }*/
        }*/
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkConnection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(scrollToList)
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * CGFloat(self.scrollToList), y: 0), animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if Preferences.backgroundImageName == "black" || Preferences.backgroundImageName == "Vibrant Paint" {
            return .lightContent
        } else {
            return .default
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var viewTagValue = 10
    var tagValue = 100
    var views = [TaskListView]()
    var labels = [UILabel]()
    var currentList = Int()
    var scrollToList = 0
    
    func checkConnection() {
        TaskerAPI.shared.getAll() { lists, error, message  in
            if error != nil {
                let alert = UIAlertController(title: error!, message: message!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { action in
                    self.checkConnection()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                TaskerAPI.shared.lists = lists!
                DispatchQueue.main.async {
                    self.setUpScrollView()
                    self.updateUI()
                }
            }
        }
    }
    
    func updateUI() {
        
        if (views.isEmpty == false) {
            var viewCount = 0
            for view in views {
                view.data = TaskerAPI.shared.lists[viewCount].tasks
                view.tableView.reloadData()
                viewCount += 1
            }
            
            var counter = 0
            for label in labels {
                label.text = TaskerAPI.shared.lists[counter].title
                counter += 1
            }
        }
        
        if Preferences.backgroundImageName == "black" || Preferences.backgroundImageName == "Vibrant Paint" {
            addButton.setImage(UIImage(named: "plus-white-thick"), for: .normal)
            editButton.setImage(UIImage(named: "ruler-white-thick"), for: .normal)
            settingsButton.setImage(UIImage(named: "settings-white-thick"), for: .normal)
        } else {
            addButton.setImage(UIImage(named: "plus-black"), for: .normal)
            editButton.setImage(UIImage(named: "ruler-black"), for: .normal)
            settingsButton.setImage(UIImage(named: "settings-black"), for: .normal)
        }
        
    }
    
    
    func setUpScrollView() {
                
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(TaskerAPI.shared.lists.count)
        
        var i = 0
        
        for _ in TaskerAPI.shared.lists {
            
            let view = TaskListView(frame: CGRect(x: 10 + self.scrollView.frame.width * CGFloat(i), y: 80, width: self.scrollView.frame.width - 20, height: self.scrollView.frame.height - 100))
            view.data = TaskerAPI.shared.lists[i].tasks
            view.cellDelegate = self
            
            if Preferences.blur {
                let color = Preferences.cellColor.withAlphaComponent(0.6)
                view.backgroundColor = color
                
                var blur = UIBlurEffect(style: .light)
                
                if Preferences.theme == "Dark" {
                    blur = UIBlurEffect(style: .dark)
                }
                
                let effectView = UIVisualEffectView (effect: blur)
                effectView.frame = view.bounds
                effectView.layer.cornerRadius = 10.0
                effectView.clipsToBounds = true
                view.addSubview(effectView)
                view.sendSubviewToBack(effectView)
            } else {
                view.backgroundColor = Preferences.cellColor
            }
            
            view.tag = i + viewTagValue
            
            let titleLabel = UILabel(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 20), size: CGSize.init(width: 0, height: 40)))
            titleLabel.text = TaskerAPI.shared.lists[i].title
            
            titleLabel.tag = i + tagValue
            titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
            
            if Preferences.backgroundImageName == "black" || Preferences.backgroundImageName == "Vibrant Paint" {
                titleLabel.textColor = UIColor.white
                //titleLabel.attributedText = NSAttributedString(string: <#T##String#>, attributes: [NSAttributedString.Key : Any]?)
            } else {
                titleLabel.textColor = UIColor.black
            }
            
            titleLabel.sizeToFit()
            
            if i == 0 {
                titleLabel.center.x = view.center.x
            } else {
                titleLabel.center.x = view.center.x - self.scrollView.frame.width / 2
            }
            
            self.labels.append(titleLabel)
            
            self.scrollView.addSubview(titleLabel)
            self.scrollView.addSubview(view)
            
            self.views.append(view)
            
            i += 1
        }
    }
    
    var taskId = Int()
    
    func performSegueFromCell(taskId: Int) {
        self.taskId = taskId
        self.performSegue(withIdentifier: "editTaskSegue", sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<TaskerAPI.shared.lists.count {
            let label = scrollView.viewWithTag(i + tagValue) as! UILabel
            let view = scrollView.viewWithTag(i + viewTagValue) as! TaskListView
            
            let scrollContentOffset = scrollView.contentOffset.x + self.scrollView.frame.width
            let viewOffset = (view.center.x - scrollView.bounds.width / 4) - scrollContentOffset
            label.center.x = scrollContentOffset - ((scrollView.bounds.width / 4 - viewOffset) / 2)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.currentList = Int(pageNumber)
    }
    
    @IBAction func editAction(_ sender: Any) {
        performSegue(withIdentifier: "editTaskListSegue", sender: nil)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Title", message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        let listAction = UIAlertAction(title: "New List", style: .default, handler: {(alert: UIAlertAction!) in
            self.performSegue(withIdentifier: "newTaskListSegue", sender: nil)
        })
        let taskAction = UIAlertAction(title: "New Task", style: .default, handler: {(alert: UIAlertAction!) in
            self.performSegue(withIdentifier: "newTaskSegue", sender: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in
            // print("cancel")
        })
        
        alertController.addAction(listAction)
        alertController.addAction(taskAction)
        //alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "newTaskSegue") {
            let controller = segue.destination as! TaskEditController
            controller.listId = TaskerAPI.shared.lists[currentList].id!
            controller.new = true
            controller.currentList = self.currentList
        } else if (segue.identifier == "editTaskSegue") {
            let controller = segue.destination as! TaskEditController
            controller.listId = TaskerAPI.shared.lists[currentList].id!
            controller.new = false
            controller.currentList = self.currentList
            controller.task = TaskerAPI.shared.lists[currentList].tasks![self.taskId]
        } else if (segue.identifier == "editTaskListSegue") {
            let controller = segue.destination as! TaskListEditController
            controller.currentList = currentList
            controller.scrollTo = currentList
        } else if (segue.identifier == "newTaskListSegue") {
            let controller = segue.destination as! TaskListEditController
            controller.scrollTo = currentList
        }
    }
 

}

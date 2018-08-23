//
//  TaskerAPI.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 27.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation
import UIKit

class TaskerAPI {
    
    static let shared = TaskerAPI()
    var lists = [TaskList]()
    let urlString = "http://localhost:8888/Tasker/"
    
    private init() {}
    
    
    func checkConnectivity(completion: @escaping (String?, String?) -> Void) {
        
        let url = URL(string: "http://localhost:8888/Tasker/")
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if error != nil {
                if let e = error as? URLError, e.code == .notConnectedToInternet {
                    completion("No Internet", "Make sure your device has a working internet connection.")
                } else {
                    completion("Server Down", "We're having issues with our service try again later.")
                }
            } else {
                print("SUCCESS")
                completion(nil, nil)
            }
        }.resume()
    }
    
    
    func deleteUser() {
        let url = URL(string: urlString + "/\(Preferences.defaults.integer(forKey: "userId")))")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue(Preferences.getKey(), forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error calling DELETE user")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                // CHECK FOR ERRORS
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    // all good
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // Mark: - get all tasks and lists
    
    // Data, Error, Message
    func getAll(completion: @escaping ([TaskList]?, String?, String?) -> Void) {
        /*let lists = [TaskList]()
         let response = String()
        let netError = String()*/
        
        let url = URL(string: urlString + "tasks/" + String(Preferences.defaults.integer(forKey: "userId")))
        
        var request = URLRequest(url: url!)
        request.setValue(Preferences.getKey(), forHTTPHeaderField: "Authorization")
  
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in // 4
            if error != nil {
                if let e = error as? URLError, e.code == .notConnectedToInternet {
                   // print("No Internet")
                    completion(nil, "No Internet", "Make sure your device has a working internet connection.")
                } else {
                   // print("Server Down")
                    completion(nil, "Server Down", "We're having issues with our service try again later.")
                }
            }
            
            guard let data = data else {
                print("Error getAll(): \(String(describing: error))") // 5
                return
            }
            
            do {
                
                guard let receivedJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
            
                // CHECK FOR ERRORS
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    /*
                    guard let json = String.init(data: data, encoding: String.Encoding.utf8) else {
                        print("ERROR JSON")
                        return
                    }*/
                    
                    // all good
                    let result = try JSONDecoder().decode(Root.self, from: data /*Data(json.utf8)*/)
                    
                    completion(result.data, nil, nil)
                }
                /*
                let result = try JSONDecoder().decode(Root.self, from: Data(json.utf8))
                
                completion(result.data)
            */
            } catch {
                
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: - CREATION FUNCTIONS
    
    func newTask(task: Task, listId: Int) {
        let taskData : [String:Any] = ["Name": task.name, "Description": task.description, "DueDate": task.dueDate, "ListId": String(listId), "UserId": String(Preferences.defaults.integer(forKey: "userId"))]
        let data : Data
        let url = URL(string: urlString + "tasks")
        
        var authURLRequest = URLRequest(url: url!)
        authURLRequest.httpMethod = "POST"
        authURLRequest.setValue(Preferences.getKey(), forHTTPHeaderField: "Authorization")
        authURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        do {
            data = try JSONSerialization.data(withJSONObject: taskData, options: .prettyPrinted)
            authURLRequest.httpBody = data
        } catch {
            print("JSON DATA CREATION FAILED")
        }

        let task = URLSession.shared.dataTask(with: authURLRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on /tasks")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                // CHECK FOR ERRORS
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    // all good
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func newTaskList(taskList: TaskList) {
        let taskListData : [String:String] = ["Title": taskList.title, "UserId": String(Preferences.defaults.integer(forKey: "userId"))]
        let data : Data
        let url = URL(string: urlString + "lists")
        
        var authURLRequest = URLRequest(url: url!)
        authURLRequest.httpMethod = "POST"
        authURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            data = try JSONSerialization.data(withJSONObject: taskListData, options: .prettyPrinted)
            authURLRequest.httpBody = data
        } catch {
            print("JSON DATA CREATION FAILED")
        }
        
        let task = URLSession.shared.dataTask(with: authURLRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on /tasks")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    // all good
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: - UPDATE FUNCTIONS
    
    func updateTask(task: Task) {
        let taskData : [String:String] = ["Name": task.name, "Description": task.description, "DueDate": task.dueDate]
        let data : Data
        let url = URL(string: urlString + "tasks/\(task.id!)")
                
        var authURLRequest = URLRequest(url: url!)
        authURLRequest.httpMethod = "PUT"
        authURLRequest.setValue(Preferences.getKey(), forHTTPHeaderField: "Authorization")
        authURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            data = try JSONSerialization.data(withJSONObject: taskData, options: .prettyPrinted)
            authURLRequest.httpBody = data
        } catch {
            print("JSON DATA CREATION FAILED")
        }
        
        let task = URLSession.shared.dataTask(with: authURLRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on /tasks")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                // CHECK FOR ERRORS
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    // all good
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func updateTaskList(taskList: TaskList) {
        let taskListData : [String:String] = ["Title": taskList.title]
        let data : Data
        let url = URL(string: urlString + "lists/\(taskList.id!)")
        
        var authURLRequest = URLRequest(url: url!)
        authURLRequest.httpMethod = "PUT"
        authURLRequest.setValue(Preferences.getKey(), forHTTPHeaderField: "Authorization")
        authURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            data = try JSONSerialization.data(withJSONObject: taskListData, options: .prettyPrinted)
            authURLRequest.httpBody = data
        } catch {
            print("JSON DATA CREATION FAILED")
        }
        
        let task = URLSession.shared.dataTask(with: authURLRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on /tasks")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                // CHECK FOR ERRORS
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    // all good
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: - DELETE FUNCTIONS
    
    func deleteTask(taskId: Int) {
        let url = URL(string: urlString + "tasks/\(taskId)")
        
        var authURLRequest = URLRequest(url: url!)
        authURLRequest.httpMethod = "DELETE"
        authURLRequest.setValue(Preferences.getKey(), forHTTPHeaderField: "Authorization")
        authURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: authURLRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on /tasks")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                // CHECK FOR ERRORS
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    // all good
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func deleteTaskList(taskListId: Int) {
        let url = URL(string: urlString + "lists/\(taskListId)")
        
        var authURLRequest = URLRequest(url: url!)
        authURLRequest.httpMethod = "DELETE"
        authURLRequest.setValue(Preferences.getKey(), forHTTPHeaderField: "Authorization")
        authURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: authURLRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on /tasks")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                // CHECK FOR ERRORS
                if (receivedJSON["status"] as! Int != 200) {
                    print(receivedJSON)
                } else {
                    // all good
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

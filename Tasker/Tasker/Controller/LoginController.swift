//
//  LoginController.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 25.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.hideKeyboardWhenTappedAround()
        setUpUI()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateViews()
        checkConnection()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signupView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    func checkConnection() {
        TaskerAPI.shared.checkConnectivity(completion: { error, message in
            if error != nil {
                let alert = UIAlertController(title: error!, message: message!, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { action in
                    self.checkConnection()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func setUpUI() {
        
        loginView.isHidden = true
        signupView.isHidden = true
 
        loginView.layer.cornerRadius = 10.0
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.layer.shadowOpacity = 0.2
        loginView.layer.shadowOffset = CGSize.zero
        loginView.layer.shadowRadius = 10
        
        signupView.layer.cornerRadius = 10.0
        signupView.layer.shadowColor = UIColor.black.cgColor
        signupView.layer.shadowOpacity = 0.2
        signupView.layer.shadowOffset = CGSize.zero
        signupView.layer.shadowRadius = 10
        
        emailField.borderStyle = .roundedRect
        emailField.layer.cornerRadius = 7.5
        emailField.backgroundColor = UIColor.white
        emailField.layer.borderWidth = 2.0
        emailField.layer.borderColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0).cgColor
        emailField.layer.masksToBounds = true
        emailField.textColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0)
        
        passwordField.borderStyle = .roundedRect
        passwordField.layer.cornerRadius = 7.5
        passwordField.backgroundColor = UIColor.white
        passwordField.layer.borderWidth = 2.0
        passwordField.layer.borderColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0).cgColor
        passwordField.layer.masksToBounds = true
        passwordField.textColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0)
 
        loginButton.backgroundColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.5
        loginButton.layer.shadowOffset = CGSize.zero
        loginButton.layer.shadowRadius = 10
        
        signUpButton.backgroundColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        signUpButton.layer.cornerRadius = 10.0
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOpacity = 0.5
        signUpButton.layer.shadowOffset = CGSize.zero
        signUpButton.layer.shadowRadius = 10
    }
    
    func animateViews() {

        let finalYLogin = loginView.center.y
        let finalXLogin = loginView.center.x
        let finalYSignUp = signupView.center.y
        let finalXSignUp = signupView.center.x
        
        let fromY = self.view.bounds.maxY + 100
        let fromX = (self.view.bounds.maxX - self.view.frame.width / 2)
        
        loginView.center.y = fromY
        loginView.center.x = fromX
        signupView.center.y = fromY
        signupView.center.x = fromX
        
        loginView.isHidden = false
        signupView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            self.loginView.center.y = finalYLogin - 20
            self.loginView.center.x = finalXLogin
            self.signupView.center.y = finalYSignUp - 20
            self.signupView.center.x = finalXSignUp
        }, completion: { (value: Bool) in
            UIView.animate(withDuration: 0.25, animations: {
                //animation 2
                self.loginView.center.y = finalYLogin
                self.signupView.center.y = finalYSignUp
            })
        })
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        guard let email = self.emailField.text else {
            print("ERROR EMPTY EMAIL")
            return
        }
        
        guard let password = self.passwordField.text else {
            print("ERROR EMPTY PASSWORD")
            return
        }
        
        let authData : [String:String] = ["Email": email, "Password": password]
        let data : Data
        
        let endpoint : String = "http://localhost:8888/Tasker/auth/login"
        guard let authURL = URL(string: endpoint) else {
            print("URL ERROR")
            return
        }
        
        var authURLRequest = URLRequest(url: authURL)
        authURLRequest.httpMethod = "POST"
        authURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            data = try JSONSerialization.data(withJSONObject: authData, options: .prettyPrinted)
            authURLRequest.httpBody = data
        } catch {
            print("JSON DATA CREATION FAILED")
        }
        
        let task = URLSession.shared.dataTask(with: authURLRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling POST on /Tasker/auth")
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
                
                if (receivedJSON["status"] as! Int != 401) {
                    let userData : [String: Any] = receivedJSON["data"] as! [String : Any]
                    Preferences.defaults.set(userData["key"] as! String, forKey: "apiKey")
                    Preferences.defaults.set(userData["userId"] as! Int, forKey: "userId")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    
                    // TODO: - Save api key in keychain
                    // base 64 encode requests
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    
                    let alert = UIAlertController(title: "Error", message: "\(String(describing: receivedJSON["status"])): \(String(describing: receivedJSON["data"]))", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
 
    }
 
    @IBAction func signUpButtonAction(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

 }

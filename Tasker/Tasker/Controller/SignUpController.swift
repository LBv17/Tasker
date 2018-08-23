//
//  SignUpController.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 25.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        setUpUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateView()
    }
    
    @IBOutlet weak var signupView: UIView!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    func setUpUI() {
        
        signupView.isHidden = true
        
        signupView.layer.cornerRadius = 10.0
        signupView.layer.shadowColor = UIColor.black.cgColor
        signupView.layer.shadowOpacity = 0.2
        signupView.layer.shadowOffset = CGSize.zero
        signupView.layer.shadowRadius = 10
        
        let textFields = [firstNameField, lastNameField, emailField, passwordField, rePasswordField]
        
        for textField in textFields {
            
            textField!.borderStyle = .roundedRect
            textField!.layer.cornerRadius = 7.5
            textField!.backgroundColor = UIColor.white
            textField!.layer.borderWidth = 2.0
            textField!.layer.borderColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0).cgColor
            textField!.layer.masksToBounds = true
            textField!.textColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0)
            /*
            let bottomLine = CALayer()
            bottomLine.frame = CGRect.init(x: 0, y: textField!.frame.size.height - 1, width: textField!.frame.size.width, height: 1)
            bottomLine.backgroundColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0).cgColor
            
            textField?.layer.addSublayer(bottomLine)
            textField?.borderStyle = .none
            */
        }
        
        signUpButton.backgroundColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOpacity = 0.2
        signUpButton.layer.shadowOffset = CGSize.zero
        signUpButton.layer.shadowRadius = 10
        
        backButton.backgroundColor = UIColor(red: 2/255, green: 36/255, blue: 87/255, alpha: 1.0)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = 10
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOpacity = 0.2
        backButton.layer.shadowOffset = CGSize.zero
        backButton.layer.shadowRadius = 10
    }
    
    func animateView() {
        
        let finalYSignUp = signupView.center.y
        let finalXSignUp = signupView.center.x
        
        let fromY = self.view.bounds.maxY + 100
        let fromX = (self.view.bounds.maxX - self.view.frame.width / 2)
        
        signupView.center.y = fromY
        signupView.center.x = fromX
        
        signupView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            self.signupView.center.y = finalYSignUp - 20
            self.signupView.center.x = finalXSignUp
        }, completion: { (value: Bool) in
            UIView.animate(withDuration: 0.25, animations: {
                self.signupView.center.y = finalYSignUp
            })
        })
        
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        print("signup pressed")
        
        guard let fname = self.firstNameField.text else {
            print("ERROR EMPTY fname")
            return
        }
        
        guard let lname = self.lastNameField.text else {
            print("ERROR EMPTY lname")
            return
        }
        
        guard let email = self.emailField.text else {
            print("ERROR EMPTY EMAIL")
            return
        }
        
        guard let password = self.passwordField.text else {
            print("ERROR EMPTY PASSWORD")
            return
        }
        
        guard let password2 = self.rePasswordField.text else {
            print("ERROR EMPTY PASSWORD")
            return
        }
        
        let registerData : [String:String] = ["fName": fname, "lName": lname, "email": email, "password": password, "password2": password2]
        let data : Data
        
        let endpoint : String = "http://localhost:8888/Tasker/auth/register"
        guard let registerURL = URL(string: endpoint) else {
            print("URL ERROR")
            return
        }
        
        var registerURLRequest = URLRequest(url: registerURL)
        registerURLRequest.httpMethod = "POST"
        registerURLRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            data = try JSONSerialization.data(withJSONObject: registerData, options: .prettyPrinted)
            registerURLRequest.httpBody = data
        } catch {
            print("JSON DATA CREATION FAILED")
        }
        
        let task = URLSession.shared.dataTask(with: registerURLRequest) { (data, response, error) in
            
            guard error == nil else {
                print("error calling POST on /Tasker/auth/register")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            print(responseData)
            do {
                guard let receivedJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                print(receivedJSON)
                
                if receivedJSON["status"] as! Int == 1 || receivedJSON["status"] as! Int == 2 {
                    let alert = UIAlertController(title: "Error", message: receivedJSON["data"] as? String, preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)

                } else if receivedJSON["status"] as! Int == 123 {
                    let alert = UIAlertController(title: "Error", message: "Fatal Error: \(String(describing: receivedJSON["data"] as? String))", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)

                } else if receivedJSON["status"] as! Int == 200 {
                    let alert = UIAlertController(title: "Success", message: "You can log in now!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Let's Go", style: UIAlertAction.Style.default, handler: { action in
                        self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
                    }))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)

                } else {
                    print("fuck")
                }
                
            } catch {
                print("ERROR IN CATCH \(error)")
            }
        }
        task.resume()
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
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

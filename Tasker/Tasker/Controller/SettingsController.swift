//
//  SettingsController.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 07.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import UIKit
import SafariServices

class SettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("ViewDidLoad: ")
        print(Preferences.cellColor.description)
        print(Preferences.theme)
        
        updateUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var blurLabel: UILabel!
    @IBOutlet weak var wallpaperLabel: UILabel!
    @IBOutlet weak var resetPasswordButtonLabel: UIButton!
    @IBOutlet weak var websiteButtonLabel: UIButton!
    @IBOutlet weak var donateButtonLabel: UIButton!
    @IBOutlet weak var disclaimerButtonLabel: UIButton!
    
    func updateUI() {
        
        let labels = [themeLabel, blurLabel, wallpaperLabel]
        
        for label in labels {
           label?.textColor = Preferences.textColor
        }
        
        let buttons = [resetPasswordButtonLabel, websiteButtonLabel, donateButtonLabel, disclaimerButtonLabel]
        
        for button in buttons {
            button?.setTitleColor(Preferences.textColor, for: .normal)
        }
        
        super.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : Preferences.textColor]
        
        if Preferences.theme == "Dark" {
            themeSwitch.isOn = true
            super.navigationController?.navigationBar.barStyle = .black
            self.tableView.backgroundColor = UIColor.black
            self.tableView.separatorColor = UIColor.darkGray
            for section in 0...2 {
                self.tableView.headerView(forSection: section)?.detailTextLabel!.textColor = UIColor.lightText
            }
        } else if Preferences.theme == "Default" {
            themeSwitch.isOn = false
            super.navigationController?.navigationBar.barStyle = .default
            self.tableView.backgroundColor = UIColor(displayP3Red: 237/255, green: 236/255, blue: 242/255, alpha: 1.0)
            self.tableView.separatorColor = UIColor.lightGray
            for section in 0...2 {
                self.tableView.headerView(forSection: section)?.textLabel!.textColor = UIColor(displayP3Red: 111/255, green: 113/255, blue: 121/255, alpha: 1.0)
            }
        }
        
        if Preferences.blur {
            blurSwitch.isOn = true
        } else {
            blurSwitch.isOn = false
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Preferences.cellColor
    }
    
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var blurSwitch: UISwitch!
    
    @IBAction func themeChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            print("switched to default")
            Preferences.theme = "Default"
            Preferences.textColor = UIColor.black
            Preferences.cellColor = UIColor.white
            Preferences.taskSeparatorColor = UIColor.black
        } else {
            print("switch to dark")
            Preferences.theme = "Dark"
            Preferences.textColor = UIColor.white
            Preferences.cellColor = UIColor.black
            Preferences.taskSeparatorColor = UIColor.white
            // switch to dark
        }
        updateUI()
    }
    
    @IBAction func blurChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            print("switched to blur off")
            Preferences.blur = false
        } else {
            print("switch to blur on")
            Preferences.blur = true
        }
        updateUI()
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        print("pressed")
    }
    
    @IBAction func logOut(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "This will log you out of the app, none of your data will be lost.", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertAction.Style.destructive, handler: { action in
            // LOG OUT ACCOUNT HERE
            // Remove API KEY
            // set app launched to 0
            
            Preferences.defaults.set("", forKey: "apiKey")
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account", message: "This will erase all of your data, make it unrecoverable and you will no longer be able to log in with your current account!", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
            // DELETE ACCOUNT HERE
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func websiteAction(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string: "http://lorenzobaldassarri.ddns.net/lb")!)
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func donateAction(_ sender: Any) {
        // not supported yet
    }
    
    @IBAction func disclaimerAction(_ sender: Any) {
        let alert = UIAlertController(title: "Disclaimer", message: "Login Data is transfered via POST in plaintext, the API Key is not stored or transmitted securely between client and server for now, user this application at your own risk.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "doneSettingsSegue" {
            Preferences.savePreferences()
        }
    }
    

}

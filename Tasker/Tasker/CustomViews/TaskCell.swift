//
//  TaskCell.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 27.07.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    
    let nameLabel:UILabel = {
        let label = UILabel()
        // label.backgroundColor = UIColor.purple
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor =  UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateDetailLabel:UILabel = {
        let label = UILabel()
        // label.backgroundColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor =  UIColor.black
        //label.backgroundColor =  UIColor(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        //label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        // view.backgroundColor = UIColor.brown
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    let completedButton : UIButton = {
        let button = UIButton()
        // button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        // button.backgroundColor = UIColor.green
        // button.setImage(UIImage(named: "checkmark"), for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let editButton : UIButton = {
        let button = UIButton()
        // button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        // button.backgroundColor = UIColor.green
         // button.setImage(UIImage(named: "edit-1"), for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    var onButtonTapped : (() -> Void)? = nil
    
    @IBAction @objc func favoriteClicked(sender: UIButton) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
    var message: String?
    var detail: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateDetailLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(completedButton)
        self.contentView.addSubview(editButton)

        containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        containerView.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        completedButton.widthAnchor.constraint(equalToConstant:32).isActive = true
        completedButton.heightAnchor.constraint(equalToConstant:32).isActive = true
        completedButton.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        completedButton.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        
        editButton.widthAnchor.constraint(equalToConstant:32).isActive = true
        editButton.heightAnchor.constraint(equalToConstant:32).isActive = true
        editButton.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -52).isActive = true
        editButton.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        
        dateDetailLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        dateDetailLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        dateDetailLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        dateDetailLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

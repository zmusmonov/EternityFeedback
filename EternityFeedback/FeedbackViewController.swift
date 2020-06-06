//
//  FeedbackViewController.swift
//  EternityFeedback
//
//  Created by ZiyoMukhammad Usmonov on 5/1/20.
//  Copyright © 2020 ZiyoMukhammad Usmonov. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {

    private let telegramService = TelegramService()
    
    //MARK:- UI Setup
    
    private let descriptionLabel = UILabel()
    
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = "Enter your name"
        nameTextField.font = .systemFont(ofSize: 18)
        nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        return nameTextField
    }()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "Enter your email"
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        return emailTextField
    }()
    
    private let feedbackTextField: UITextField = {
        let feedbackTextField = UITextField()
        feedbackTextField.placeholder = "Enter your feedback"
        feedbackTextField.font = .systemFont(ofSize: 18)
        feedbackTextField.borderStyle = UITextField.BorderStyle.roundedRect
        return feedbackTextField
    }()
    
    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.tintColor = .white
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(self.submitButtonPressed), for: .touchUpInside)
        return submitButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setViewConstraints()
    }
    
    func setupViews() {
        
        view.addSubview(descriptionLabel)
        view.addSubview(emailTextField)
        view.addSubview(nameTextField)
        view.addSubview(feedbackTextField)
        view.addSubview(submitButton)
        
    }
    
    func setViewConstraints() {
        
        for view in [descriptionLabel, submitButton, emailTextField, nameTextField, feedbackTextField] {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 36).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -36).isActive = true
            
        }
        
        //description label
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //email text view
        emailTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //name text view
        nameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        //name text view
        feedbackTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8).isActive = true
        feedbackTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feedbackTextField.heightAnchor.constraint(equalToConstant: 132.0).isActive = true
        feedbackTextField.contentVerticalAlignment = .top
        
        //button
        submitButton.topAnchor.constraint(equalTo: feedbackTextField.bottomAnchor, constant: 8).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    //MARK:- Business logic
    
    @objc func submitButtonPressed() {
        
        if feedbackTextField.text == "" || emailTextField.text == "" || nameTextField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please fill all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let text = "Email: \(emailTextField.text!), Name: \(String(describing: nameTextField.text!)), Feedback: \(feedbackTextField.text!)"
        
        telegramService.sendMessage(text)
        
        
        clearTextFields()

    }
    
    func clearTextFields() {
        nameTextField.text = ""
        emailTextField.text = ""
        feedbackTextField.text = ""
    }
    
}
//

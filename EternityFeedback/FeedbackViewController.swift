    //
    //  FeedbackViewController.swift
    //  EternityFeedback
    //
    //  Created by ZiyoMukhammad Usmonov on 5/1/20.
    //  Copyright © 2020 ZiyoMukhammad Usmonov. All rights reserved.
    //

    import UIKit

    class FeedbackViewController: UIViewController, UITextViewDelegate {
        
        private let botToken = "BOT_TOKEN"
        private let chatID = "CHAT_ID"
        private let urlString = "https://api.telegram.org"
        
        let descriptionLabel = UILabel()
        let nameTextField = UITextField()
        let emailTextField = UITextField()
        let feedbackTextField = UITextField()
        let submitButton = UIButton()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupViews()
        }
        
        func setupViews() {
            
            //description labell
            descriptionLabel.text = "Please provide the information below and submit your feedback. We will contact you soon"
            descriptionLabel.numberOfLines = 0
            descriptionLabel.textAlignment = .center
            
            //email
            emailTextField.keyboardType = .emailAddress
            emailTextField.placeholder = "Enter your email"
            emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
            
            
            //email
            nameTextField.placeholder = "Enter your name"
            nameTextField.font = .systemFont(ofSize: 18)
            nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
            
            
            //email
            feedbackTextField.placeholder = "Enter your feedback"
            feedbackTextField.font = .systemFont(ofSize: 18)
            feedbackTextField.borderStyle = UITextField.BorderStyle.roundedRect
            
            //button
            submitButton.backgroundColor = .red
            submitButton.setTitle("Submit", for: .normal)
            submitButton.addTarget(self, action: #selector(self.submitButtonPressed), for: .touchUpInside)
            
            
            
            view.addSubview(descriptionLabel)
            view.addSubview(emailTextField)
            view.addSubview(nameTextField)
            view.addSubview(feedbackTextField)
            view.addSubview(submitButton)
            
            setViewConstraints()
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
        
        @objc func submitButtonPressed() {
            if feedbackTextField.text == "" || emailTextField.text == "" || nameTextField.text == "" {
                let alert = UIAlertController(title: "Alert", message: "Please fill all fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                let message = "Email: \(emailTextField.text!), Name: \(String(describing: nameTextField.text!)), Feedback: \(feedbackTextField.text!)"
                let url = URL(string: "\(urlString)/bot\(botToken)/sendMessage?")!
                
                let params = ["chat_id": "\(chatID)", "text": "\(message)"]
                
                let session = URLSession.shared
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                } catch let error    {
                    print(error.localizedDescription)
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    guard error == nil else {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print("hello")
                            print(json)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
                
                clearTextFields()
                
            }
        }
    
        func clearTextFields() {
            nameTextField.text = ""
            emailTextField.text = ""
            feedbackTextField.text = ""
        }
        
    }
//

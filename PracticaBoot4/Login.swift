//
//  Login.swift
//  PracticaBoot4
//
//  Created by Eugenio Barquín on 15/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation
import Firebase

class Login: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var inputsViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var registerLoginButtonText: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
    }
    
    @IBAction func handleLoginRegisterChange(_ sender: Any) {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        registerLoginButtonText.setTitle(title, for: .normal)
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextField.isHidden = true
            inputsViewHeightConstraint.constant = 100
            
        } else if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            nameTextField.isHidden = false
            inputsViewHeightConstraint.constant = 150
        }
        
    }

    @IBAction func anonimouslySurf(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func loginRegisterAction(_ sender: Any) {

        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            
            handleLogin()
            
        } else {
            
            handleRegister()

        }
        
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error)
                return
            }
            //successfully logged in
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    func handleRegister() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form not valid")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user 
            //save the user also in database
            
            let values = ["name": name, "email": email]
            self.registerUserIntoDatabaseByUID(uid: uid, values: values)
            
        
        })
        
    }
    
    func registerUserIntoDatabaseByUID (uid: String, values: [String: Any]) {
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if error != nil {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
            print("succesfully saved user in FB Data Base")
        })
    }
}



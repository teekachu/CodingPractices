//
//  signUpViewController.swift
//  FirebaseTutorial
//
//  Created by Tee Becker on 10/11/20.
//

import UIKit
import FirebaseAuth

class signUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        
        // hide error label
        errorLabel.alpha = 0
        
        // style elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextfield)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    // MARK: sign up button
    @IBAction func signUpTapped(_ sender: Any) {
        
        // validate the fields
        let error = validateFields()
        if error != nil{
            // there is something wrong
            showError(message: error!)
        } else{
            // no error
            // create the user and transition to home screen
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextfield.text!) { (successResult, error) in
                
                // check for errors:
                if error != nil {
                    
                    // there is an error
                    self.showError(message: "Error due to : \(String(describing: error?.localizedDescription))")
                    
                } else{
                    
                    // user was created successfully , store firstname / lastname
                    
                }
            }
            
        
    }
    
    
    
    
    
}

// check fields and validate the data is correct. If all correct, return nil, else return error message
func validateFields() -> String? {
    
    // series of checks to return error msg
    // check if any of the fields are empty
    if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        
        return " please fill in all fields "
    }
    
    // check if pswd is secure. Use code in Utilities
    
    if let cleanPassword = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines){
        
        if Utilities.isPasswordValid(cleanPassword) == false{
            // password isn't secure enough
            return " Please make sure to include special characters and numbers in your password"
        }
    }
    
    
    return nil // everything is fine
}

func showError(message: String) {
    errorLabel.text = message
    errorLabel.alpha = 1
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

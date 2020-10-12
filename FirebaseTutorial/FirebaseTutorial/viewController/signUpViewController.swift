//
//  signUpViewController.swift
//  FirebaseTutorial
//
//  Created by Tee Becker on 10/11/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

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
            // create cleaned versions of data
            let firstName = self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailAddress = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passWord = self.passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create the user and transition to home screen
            Auth.auth().createUser(withEmail: emailAddress, password: passWord) { (successResult, error) in
                
                // check for errors:
                if error != nil {
                    
                    // there is an error
                    self.showError(message: "Error due to : \(String(describing: error?.localizedDescription))")
                    
                } else{
                    
                    // user was created successfully , store firstname / lastname
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: [
                        "firstName": firstName,
                        "lastName": lastName,

                        
                    ]) { (error) in
                        
                        if error != nil{
                            // there is an error
                            self.showError(message: "User data couldn't be saved on database side")
                            
                        }
                    }
                    
                    // transition to Home screen
                    
                    self.transitionToHome()
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
    
    func transitionToHome(){
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? homeViewController
        // made the homeVC the rootController
        view.window?.rootViewController = homeVC
        // make it the key window and visible
        view.window?.makeKeyAndVisible()

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

//
//  loginViewController.swift
//  FirebaseTutorial
//
//  Created by Tee Becker on 10/11/20.
//

import UIKit
import FirebaseAuth

class loginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
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
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passWordTextField)
        Utilities.styleHollowButton(loginButton)
    }
    
    func validateFields() -> String? {
        
        // series of checks to return error msg
        // check if any of the fields are empty
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passWordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return " please fill in all fields "
        }
        
        return nil
    }
    
    // MARK: Login button
    
    @IBAction func loginTapped(_ sender: Any) {
        // validate textfield ( all filled in )
        let error = validateFields()
        if error != nil{
            showError(message: error!)
        } else{
            // signing in the user
            signIn()
            
        }
        
    }
    
    func showError(message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func signIn(){
        //
        //create clean version of email and pass
        let emailAddress = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passWord = self.passWordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // auth per firebase documentation
        Auth.auth().signIn(withEmail: emailAddress, password: passWord) {[weak self] (authResult, error) in
            
            if error != nil{
                // could not sign in
                self?.errorLabel.text = error?.localizedDescription
                self?.errorLabel.alpha = 1
                
            } else{
                // no error, sign in successfully
                let homeVC = self?.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? homeViewController
                self?.view.window?.rootViewController = homeVC
                self?.view.window?.makeKeyAndVisible()
                
            }
            
        }
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

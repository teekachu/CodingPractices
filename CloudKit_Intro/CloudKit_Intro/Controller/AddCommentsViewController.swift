//
//  AddCommentsViewController.swift
//  CloudKit_Intro
//
//  Created by Tee Becker on 11/25/20.
//

import UIKit

class AddCommentsViewController: UIViewController {
    
    //MARK: Properties
    var genre: String!
    var commentsTextView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    let placeholderString = "If you have any additional comments that might help identify your tune, enter them here. "
    
    
    //MARK: Lifecycle
    override func loadView() {
        configureUI()
        configureTextView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: Selector
    @objc func submitTapped(){
        print("Debug: print")
        
        let vc = SubmitViewController()
        vc.genre = genre
        
        if commentsTextView.text == placeholderString{
            vc.commentsText = ""
//            showMessage(withTitle: "Did you forget to enter comments? ", message: placeholderString)
//            return
        } else {
            vc.commentsText = commentsTextView.text
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Private
    private func configureUI(){
        view = UIView()
        view.backgroundColor = Constants.darkBlueColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = Constants.mintBlueColor
        
        title = "Comments"
        commentsTextView.text = placeholderString
        let submitImage = UIImage(systemName: "checkmark.circle")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: submitImage, style: .plain, target: self, action: #selector(submitTapped))
        
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
    }
    
    private func configureTextView(){
        commentsTextView.delegate = self
        commentsTextView.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(commentsTextView)
        commentsTextView.backgroundColor = .clear
        commentsTextView.tintColor = Constants.mintBlueColor
        commentsTextView.textColor = Constants.mintBlueColor
        commentsTextView.returnKeyType = .done
        commentsTextView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: 5,
            paddingBottom: 5,
            paddingRight: 5)
    }
    
}


//MARK: Extensions

extension AddCommentsViewController: UITextViewDelegate {
    /// will be called when user starts editing the textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        /// compare textview's current text against placeholder, and clear if they match
        
        if textView.text == placeholderString{
            textView.text = ""
        }
    }
    
    
}

//
//  SubmitViewController.swift
//  CloudKit_Intro
//
//  Created by Tee Becker on 11/25/20.
//

import UIKit
import CloudKit

class SubmitViewController: UIViewController {
    
    //MARK: Properties
    var genre: String!
    
    var commentsText: String!
    
    private var stackView: UIStackView = {
        let stv = UIStackView()
        return stv
    }()
    
    private var statusLabel: UILabel = {
        let status = UILabel()
        return status
    }()
    
    private var spinner: UIActivityIndicatorView!
    
    
    //MARK: Lifecycle
    override func loadView() {
        ///Testing
        let container = CKContainer.default()
        if let containerID = container.containerIdentifier{
            print(containerID)
        }
        
        configureUI()
        configureUILabel()
        configureSpinner()
        configureStackView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confugureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        doSubmission()
    }
    
    //MARK: Selector
    @objc func doneTapped(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK: Privates
    private func configureUI(){
        view = UIView()
        view.backgroundColor = Constants.darkBlueColor
    }
    
    
    private func confugureNavBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "You are all set!"
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = Constants.peachyColor
    }
    
    
    private func configureStackView(){
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.centerY(inView: view)
        stackView.anchor(
            left: view.leftAnchor,
            right: view.rightAnchor)
        
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(spinner)
    }
    
    
    private func configureUILabel(){
        statusLabel.text = "Submitting..."
        statusLabel.textColor = Constants.mintBlueColor
        statusLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureSpinner(){
        spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = Constants.mintBlueColor
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
    }
    
    private func doSubmission(){
        /// 1) creates the record to send to iCloud
        
        /// CKRecord is like a dictionary with key and values.
        /// The recordType string identifies what type of data we are trying to safe
        let whistleRecord = CKRecord(recordType: "Whistles")
        whistleRecord["Genre"] = genre as CKRecordValue  /// typecast as CKRecordValue because they are Strings
        whistleRecord["Comments"] = commentsText as CKRecordValue
        
        let audioURL = RecordWhistleViewController.getWhistleURL()
        let whistleAsset = CKAsset(fileURL: audioURL)
        whistleRecord["Audio"] = whistleAsset
        
        /// 2) handles the result because iCloud calls are asynchrounous
        
        //        let CKcontainer = CKContainer(identifier: "iCloud.TeeksCode.CloudKit-Intro")
        CKContainer.default().publicCloudDatabase.save(whistleRecord) {[unowned self] (record, error) in
            /// Main thread because need to manipulate UI
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    statusLabel.text = "Error: \(error.localizedDescription)"
                    spinner.stopAnimating()
                } else {
                    /// no error, proceed
                    view.backgroundColor = Constants.mediumBlueColor
                    statusLabel.text = "Done!"
                    spinner.stopAnimating()
                    
                    RootViewController.isDirty = true
                }
                
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain,
                                                                    target: self, action: #selector(doneTapped))
                
            }
        }
    }
    
    
}

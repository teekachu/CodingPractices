//
//  RootViewController.swift
//  CloudKit_Intro
//
//  Created by Tee Becker on 11/24/20.

///  This app allows the user to whistle into microphone, upload to iCloud, others can download whistle and try to identify what song it is from.
///  User can choose which music genres to specialize in, and receive push message if a new whistle comes from the genre.

import UIKit
import CloudKit
/// Load data from CloudKit using the coreAPI so we can selectively download records. ( We saved records using convenience API)

class RootViewController: UITableViewController {

    //MARK: Properties
    
    static var isDirty = true /// From SubmitViewController file
    
    /// Empty array holding Whistles. Everytime the view is shown,
    /// we will refresh out data from iCloud using loadWhistles() method.
    var whistles = [Whistle]()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Going to clear the tableview's selection if it has one, then use the isDirty flag to call loadWhistles() if its needed
        if let indexpath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexpath, animated: true)
        }
        
        if RootViewController.isDirty {
            loadWhistles()
        }
        
    }

    //MARK: Selector
    @objc func addWhistle(){
        let vc = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Private
    private func configureUI(){

        configureBackgroundAndNavBar()

        title = "What's that whistle?"
        
        let image = UIImage(systemName: "house")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)

    }
    
    
    private func loadWhistles(){
        
    }
    

}


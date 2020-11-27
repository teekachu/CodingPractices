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
  
        configureBackgroundAndNavBar()
        configureUI()
        registerTableViewCells()
        
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
        title = "What's that whistle?"
        
        let image = UIImage(systemName: "house")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    /// Pull Whisltes from iCloud
    private func loadWhistles(){
        /// Describe a filter which we will use later to describe what results to show.
        /// Here it means all records that match true
        let pred = NSPredicate(value: true)
        
        /// Tell CloudKit which field we want to sort on, and whether we want it to ascend or descent
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        
        /// Combines a predicate and sort descriptors with the name of the record type we want to query.
        let query = CKQuery(recordType: "Whistles", predicate: pred)
        query.sortDescriptors = [sort]
        
        /// Worker bee of CK data fetching. Attach 2 closures where one does the fetching and one gets called after all fetching are done
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["Genre", "Comments"] /// Decleared in SubmitVC
        operation.resultsLimit = 50
        
        /// Make a new array
        var newWhistles = [Whistle]()
        
        /// Block to execute for each record returned by query
        operation.recordFetchedBlock = { record in
            let whistle = Whistle()
            whistle.recordID = record.recordID
            whistle.genre = record["Genre"]
            whistle.comments = record["Comments"]
            newWhistles.append(whistle)
        }
        
        /// Block to execute with the search results
        operation.queryCompletionBlock = {[unowned self] (cursor, error) in
            DispatchQueue.main.async {  /// UI Work so need to be on mainthread
                if error == nil{
                    RootViewController.isDirty = false
                    self.whistles = newWhistles
                    self.tableView.reloadData()
                } else {
                    showMessage(withTitle: "Fetch failed",
                                message: "There was a problem fetching the list of whistles. Please try again later. \(error!.localizedDescription)")
                }
            }
        }
        
        /// Ask Cloudkit to run the operation
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    private func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
                               NSAttributedString.Key.foregroundColor: Constants.mintBlueColor]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)",
                                                    attributes: titleAttributes)
        if subtitle.count > 0 {
            let subtitleString = NSAttributedString(string: "\n\(subtitle)",
                                                    attributes: subtitleAttributes)
            titleString.append(subtitleString)
        }
        
        return titleString
    }
    
    
    //MARK: Table view data source
    private func registerTableViewCells(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.whistles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.attributedText = makeAttributedString(title: whistles[indexPath.row].genre,
                                                              subtitle: whistles[indexPath.row].comments)
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ResultsViewController()
        vc.whistle = whistles[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    

}


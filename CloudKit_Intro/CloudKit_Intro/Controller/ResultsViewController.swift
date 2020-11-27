//
//  ResultsViewController.swift
//  CloudKit_Intro
//
//  Created by Tee Becker on 11/26/20.
//

import UIKit
import AVFoundation /// To listen to Whistles
import CloudKit  /// To download Whistles and suggestions

class ResultsViewController: UITableViewController {
    
    //MARK: Properties
    var whistle: Whistle!
    var suggestions = [String]()
    var whistlePlayer: AVAudioPlayer!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundAndNavBar()
        downloadAllSuggestionsFromCloud()
    }
    
    //MARK: Selector
    @objc func downloadTapped(){
        /// replace button with a spinner so user know that data is being fetched
        configureSpinner()
        
        /// Ask cloudkit to pulldown the full record for the whistle, as well as the audio
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: whistle.recordID) {[unowned self] (record, error) in
            if let error = error {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    showMessage(withTitle: "Uh Oh, something went wrong ",
                                message: "An error occured when downloading the whistle. Please try again later. ")
                }
            } else {
                /// if successful, attach audio to the whistle object
                if let record = record {
                    if let asset = record["Audio"] as? CKAsset {
                        self.whistle.audio = asset.fileURL
                        
                        /// create a new right bar button that says listen and call listenTapped()
                        DispatchQueue.main.async {
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Listen", style: .plain, target: self, action: #selector(listenTapped))
                        }
                    }
                }
                
            }
        }
    }
    
    
    @objc private func listenTapped(){
        /// if something goes wrong,  show error message and put the download button back
        do{
            whistlePlayer = try AVAudioPlayer(contentsOf: whistle.audio)
            whistlePlayer.play()
        } catch {
            showMessage(withTitle: "Playback failed", message: "There was a problem playing your whistle, please try to re-record")
        }
    }
    
    //MARK: Privates
    private func add(suggestion: String){
        /// When we add a suggestion, we have to tie it to which whistleRecord its related to and not the other way around.
        /// The reason for this is to avoid conflicts. If one whistle have different suggestions, cloud kit wouldnt know what to do.
        /// As such, we will make it reversed where each suggestion is related to one Whistle.
        
        /// Declare the record type
        let whistleRecord = CKRecord(recordType: "Suggestions")
        /// Record ID is just the record ID, action is the behavior to trigger when the link record is deleted. So if record is deleted, also delete the reference to it.
        let reference = CKRecord.Reference(recordID: whistle.recordID, action: .deleteSelf)
        whistleRecord["text"] = suggestion as CKRecordValue
        whistleRecord["owningWhistle"] = reference as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(whistleRecord) {[unowned self] (record, error) in
            
            DispatchQueue.main.async {
                if error == nil{
                    self.suggestions.append(suggestion)
                    self.tableView.reloadData()
                } else {
                    showMessage(withTitle: "Error", message: "An error occured submitting your suggestion. \(error!.localizedDescription)")
                }
            }
        }
    }
    
    private func downloadAllSuggestionsFromCloud(){
        /// Set up title / nav bar
        title = "Genre: \(whistle.genre!)"
        let image = UIImage(systemName: "icloud.and.arrow.down")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(downloadTapped))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        /// Link whistles together with suggestions by recordID
        let reference = CKRecord.Reference(recordID: whistle.recordID, action: .deleteSelf)
        let pred = NSPredicate(format: "owningWhistle == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: "Suggestions", predicate: pred)
        query.sortDescriptors = [sort]
        
        /// will use conventional API because we want all the fields. Used CKQueryOperation earlier in RootVC because we wanted spcificly desired keys
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) {[unowned self] (results, error) in
            if let error = error{
                print("error during downloading suggestions: \(error.localizedDescription)")
            } else {
                if let results = results{
                    /// parse the results
                    self.parseResults(records: results)
                    
                }
            }
        }
    }
    
    private func configureSpinner(){
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = Constants.mintBlueColor
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
    }
    
    private func parseResults(records: [CKRecord]){
        var newSuggestions = [String]()
        
        for record in records{
            newSuggestions.append(record["text"] as! String) /// use text because we added as "text" in func add()
        }
        
        DispatchQueue.main.async {[unowned self] in
            self.suggestions = newSuggestions
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    /// Add header the sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Suggested Songs"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        } else {
            return suggestions.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none // can not select because this just loads the suggestions made by others
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .clear
        cell.tintColor = Constants.mintBlueColor
        
        if indexPath.section == 0 {
            /// User's comment about the whistle
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            
            if whistle.comments.count == 0 {
                cell.textLabel?.text = "No Comments has been made yet. "
            } else {
                cell.textLabel?.text = whistle.comments
            }
            
        } else {
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            
            if indexPath.row == suggestions.count{
                /// extra row
                cell.textLabel?.text = "Click here to add a suggestion!"
                cell.selectionStyle = .gray
            } else {
                cell.textLabel?.text = suggestions[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Make sure the row thats tapped is the last row in the second section. Else exit method
        guard indexPath.section == 1 &&
                indexPath.row == suggestions.count else {
            print("Debug")
            return
        }
        
        /// Only show the color for a little bit.
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ac = UIAlertController(title: "Suggest a song ...", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: {[unowned self, ac] (action) in
            
            if let textfield = ac.textFields?[0]{
                /// If textfield is not empty, add the texts
                if textfield.text!.count > 0 {
                    self.add(suggestion: textfield.text!)
                }
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
}

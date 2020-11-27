//
//  SelectGenreViewConroller.swift
//  CloudKit_Intro
//
//  Created by Tee Becker on 11/25/20.
//

import UIKit

class SelectGenreViewConroller: UITableViewController {
    
    //MARK: Properties
    /// shared list of all music catagorites
    static var genres = ["Unknown",
                         "Blues",
                         "Classical",
                         "Electronic",
                         "Jazz",
                         "Metal",
                         "Pop",
                         "RnB",
                         "Rock",
                         "Soul",
                         "Rap"
    ]
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableview()
        
    }
    
    
    //MARK: Privates
    private func configureTableview(){
        title = "Select Genre"
        view.backgroundColor = Constants.darkBlueColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .plain, target: nil, action: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    //MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectGenreViewConroller.genres.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = SelectGenreViewConroller.genres[indexPath.row]
        cell.backgroundColor = .clear
        cell.tintColor = Constants.mintBlueColor
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Debug: Selected cell")
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath){
            let genre = cell.textLabel?.text ?? SelectGenreViewConroller.genres[0] // set as unknown by default
            let vc = AddCommentsViewController()
            vc.genre = genre
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

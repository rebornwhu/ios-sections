//
//  SearchResultsController.swift
//  ios-sections
//
//  Created by Xiao Lu on 10/10/15.
//  Copyright © 2015 Xiao Lu. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
    
    private let longNameSize = 6
    private let shortNamesButtonIndex = 1
    private let longNamesButtonIndex = 2
    
    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names:[String:[String]] = [String:[String]]()
    var keys: [String] = []
    var filteredNames:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filteredNames.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier, forIndexPath: indexPath)
        cell.textLabel!.text = filteredNames[indexPath.row]
        return cell
    }

    // MARK: UISearchResultsUpdating Conformance
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
        filteredNames.removeAll(keepCapacity: true)
        
        if !searchString!.isEmpty {
            let filter: String -> Bool = {
                name in let nameLength = self.names.count
                if (buttonIndex == self.shortNamesButtonIndex && nameLength >= self.longNameSize)
                    || (buttonIndex == self.longNamesButtonIndex && nameLength < self.longNameSize) {
                        return false
                }
                
                let range = name.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range != nil
            }
            
            for key in keys {
                let namesForKey = names[key]!
                let matches = namesForKey.filter(filter)
                filteredNames += matches
            }
        }
        
        tableView.reloadData()
    }

}

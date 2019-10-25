//
//  ViewController.swift
//  NavigationBarAnimation
//
//  Created by Larry Natalicio on 4/15/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Types
    
        struct Images {
            static let one = "one"
            static let two = "two"
            static let three = "three"
            
            static let four = "four"
            static let five = "five"
            static let six = "six"
        }
    
    
    // MARK: - Properties

    var entries = [
        Entry(title: "First Entry", image: UIImage(named: Images.one)!),
        Entry(title: "Exploring", image: UIImage(named: Images.two)!),
        Entry(title: "Traveling Abroad", image: UIImage(named: Images.three)!),
        Entry(title: "Scuba Diving", image: UIImage(named: Images.four)!),
        Entry(title: "Trip Together", image: UIImage(named: Images.five)!),
        Entry(title: "The Unknown", image: UIImage(named: Images.six)!)
    ]
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
         navigationController?.hidesBarsOnSwipe = true

    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EntryCell
        
        let entry = entries[indexPath.row]
        
        cell.entryTitle.text = entry.title
        cell.entryImage.image = entry.image
        
        return cell
    }
    
    // MARK: - Convenience
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
 
 
}


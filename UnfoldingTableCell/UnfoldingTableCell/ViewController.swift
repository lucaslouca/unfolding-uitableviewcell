//
//  ViewController.swift
//  UnfoldingTableCell
//
//  Created by Lucas Louca on 11/07/15.
//  Copyright © 2015 Lucas Louca. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableView: UITableView!
    
    let tableViewCellHeightExpanded: CGFloat = 178
    let tableViewCellHeight: CGFloat = 80
    let tableViewEstimatedRowHeight:CGFloat = 80
    let tableViewCellIdentifier = "UnfoldingTableViewCell"
    let tableViewCellNibName = "UnfoldingTableViewCell"
    var items: [(String,String)] = [("Lorem ipsum dolor sit amet", "consectetur adipiscing elit"), ("Sed do eiusmod tempor", "incididunt ut labore"), ("Et dolore", "magna aliqua")]
    var expandedIndexPaths = NSMutableSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table cell nib
        let tableViewCellNib = UINib(nibName: tableViewCellNibName, bundle: nil)
        tableView.registerNib(tableViewCellNib, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableViewEstimatedRowHeight
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UnfoldingTableViewCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as! UnfoldingTableViewCell
        
        let (title, details) = items[indexPath.row]
        cell.titleLabel.text = title
        cell.detailLabel.text = details
        
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if expandedIndexPaths.containsObject(indexPath) {
            return tableViewCellHeightExpanded
        } else {
            return tableViewCellHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if expandedIndexPaths.containsObject(indexPath) {
            expandedIndexPaths.removeObject(indexPath)
            tableView.beginUpdates()
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! UnfoldingTableViewCell
            cell.fold(nil)
            tableView.endUpdates()
        } else {
            expandedIndexPaths.addObject(indexPath)
            tableView.beginUpdates()
            
            tableView.endUpdates()
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! UnfoldingTableViewCell
            cell.unfold(nil)
        }
    }
    
}


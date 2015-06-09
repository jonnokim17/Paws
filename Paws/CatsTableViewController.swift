//
//  CatsTableViewController.swift
//  Paws
//
//  Created by Jonathan Kim on 6/8/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit

class CatsTableViewController: PFQueryTableViewController {

    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className);

        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25

        self.parseClassName = className
    }

    required init!(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func queryForTable() -> PFQuery {
        var query:PFQuery = PFQuery(className: self.parseClassName!)

        /*
        In case the query is empty, we set the cachePolicy property on the query. It’s value is constant PFCachePolicy.CacheThenNetwork, which means the query will first look in the offline cache for objects and if it doesn’t find any, it will download the objects from the online Parse datastore. When the table view is first put on screen, in our app, this if-statement is most likely to get executed once.
        */
        if (objects?.count == 0) {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }

        query.orderByAscending("name")

        return query
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier: String = "Cell"

        var cell: PFTableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? PFTableViewCell

        if (cell == nil) {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }

        if let pfObject = object {
            cell?.textLabel?.text = pfObject["name"] as? String
        }

        return cell
    }

}

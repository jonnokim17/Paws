//
//  CatsTableViewController.swift
//  Paws
//
//  Created by Jonathan Kim on 6/8/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

//Source: http://www.appcoda.com/instagram-app-parse-swift/

import UIKit

class CatsTableViewController: PFQueryTableViewController {

    let cellIdentifier: String = "CatCell"

    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className);

        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25

        self.parseClassName = className

        self.tableView.rowHeight = 350
        self.tableView.allowsSelection = false
    }

    required init!(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {

        tableView.registerNib(UINib(nibName: "CatsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

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

        var cell: CatsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? CatsTableViewCell

        if (cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("CatsTableViewCell", owner: self, options: nil)[0] as? CatsTableViewCell
        }

        cell?.parseObject = object

        if let pfObject = object {
            cell?.catNameLabel?.text = pfObject["name"] as? String

            var votes: Int? = pfObject["votes"] as? Int
            if votes == nil {
                votes = 0
            }
            cell?.catVotesLabel?.text = "\(votes!) votes"

            var credit: String? = pfObject["cc_by"] as? String
            if credit != nil {
                cell?.catCreditLabel?.text = "\(credit!) / CC 2.0"
            }

            // download image from parse
            cell?.catImageView?.image = nil

            if var urlString: String? = pfObject["url"] as? String {
                var url: NSURL? = NSURL(string: urlString!)

                if var url: NSURL? = NSURL(string: urlString!) {
                    var error: NSError?
                    var request: NSURLRequest = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5.0)

                    NSOperationQueue.mainQueue().cancelAllOperations()

                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, imageData: NSData!, error: NSError!) -> Void in
                        cell?.catImageView?.image = UIImage(data: imageData)
                    })
                }
            }
        }

        return cell
    }

}

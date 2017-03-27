//
//  ViewController.swift
//  Lecture10
//
//  Created by Aleksandar Stanojcic on 3/22/17.
//  Copyright © 2017 Aleksandar Stanojcic. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate  {
  
    var tweets = [[Tweet]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.estimatedRowHeight = tweetTableView.rowHeight
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }
    
    var searchText: String? = "#stanford" {
        
        didSet {
            searchTextField?.text = searchText
            tweets.removeAll()
            refresh()
        }
    }
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    func refresh() {
        
        if searchText != nil {
            let request = Request(search: searchText!, count: 100)
            request.fetchTweets { (newTweets) in
                
                DispatchQueue.main.async {
                    if newTweets.count > 0 {
                        self.tweets.insert(newTweets, at: 0)
                        self.tweetTableView.reloadData()
                    }
                }
            }
        }
    }
    
    private struct StoryBoard {
       static let CellIdentifier = "Tweet"
       static let MentionsIdentifier = "Show Mentions"
    }
    
    @IBOutlet weak var searchTextField: UITextField!{
        
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.CellIdentifier, for : indexPath as IndexPath) as! TweetTableViewCell
        //print(tweets)
       
        cell.tweet = tweets[indexPath.section][indexPath.row]
        
        
        return cell
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == StoryBoard.MentionsIdentifier {
            if let tweetCell = sender as? TweetTableViewCell {
                if tweetCell.tweet!.hashtags.count + tweetCell.tweet!.urls.count + tweetCell.tweet!.userMentions.count + tweetCell.tweet!.media.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == StoryBoard.MentionsIdentifier {
                if let mtvc = segue.destination as? MentionsViewController {
                    if let tweetCell = sender as? TweetTableViewCell {
                        mtvc.tweet = tweetCell.tweet
                    }
                }
            }
        }
    }
}

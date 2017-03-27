//
//  MentionsViewController.swift
//  Lecture10
//
//  Created by Aleksandar Stanojcic on 3/24/17.
//  Copyright © 2017 Aleksandar Stanojcic. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    //MARK: - Properties(Public)
    
    var mentions: [Mentions] = []
    
    @IBOutlet weak var mentionsTableView: UITableView!
    
    var tweet: Tweet? {
        
        didSet {
            title = tweet?.user.screenName
            
            if let media = tweet?.media {
                if media.count > 0 {
                    mentions.append(Mentions(title: Title.images, data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
                }
            }
            
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(title: Title.urls, data: urls.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(title: Title.hashtags, data: hashtags.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            
            if let users = tweet?.userMentions {
                if users.count > 0 {
                    mentions.append(Mentions(title: Title.users, data: users.map { MentionItem.Keyword($0.keyword) }))
                }
            }
        }
    }
    
    struct Mentions: CustomStringConvertible {
        
        var title: String
        var data: [MentionItem]
        
        var description: String { return "\(title): \(data)" }
    }
    
    enum MentionItem: CustomStringConvertible {
        
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    //MARK: - Properties(Private)
    
    private struct Title {
        static let images = "Images"
        static let urls = "URLs"
        static let hashtags = "Hashtags"
        static let users = "Users"
    }
    
    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "Keyword Cell"
        static let ImageCellReuseIdentifier = "Image Cell"
        static let KeywordSegueIdentifier = "From Keyword"
        static let ImageSegueIdentifier = "Show Image"
    }
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mentionsTableView.delegate = self
        mentionsTableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
            
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.KeywordCellReuseIdentifier,
                for: indexPath as IndexPath) as UITableViewCell
            cell.textLabel?.text = keyword
            
            return cell
            
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.ImageCellReuseIdentifier,
                for: indexPath as IndexPath) as! ImageTableViewCell
            cell.imageUrl = url
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    
    // MARK: - Navitation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.KeywordSegueIdentifier {
                if let tvc = segue.destination as? TweetViewController {
                    if let cell = sender as? UITableViewCell {
                        tvc.searchText = cell.textLabel?.text
                    }
                }
            } else if identifier == Storyboard.ImageSegueIdentifier {
                if let ivc = segue.destination as? ImageViewController {
                    if let cell = sender as? ImageTableViewCell {
                        ivc.imageURL = cell.imageUrl
                        //ivc.title = title
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if identifier == Storyboard.KeywordSegueIdentifier {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
                        return false
                    }
                }
            }
        }
        return true
    }
}

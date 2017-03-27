//
//  TweetTableViewCell.swift
//  Lecture10
//
//  Created by Aleksandar Stanojcic on 3/23/17.
//  Copyright © 2017 Aleksandar Stanojcic. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet:Tweet? {
        didSet {
            
            updateUI()
        }
    }
    
    var hashtagColor = UIColor.blue
    var urlColor = UIColor.red
    var userMentionsColor = UIColor.green
    
    //MARK: - Private API
    
    private func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        if let tweet = self.tweet {
            var text = tweet.text
            
            for _ in tweet.media {
                text += " 📷"
            }
            
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.changeKeywordsColor(keywords: tweet.hashtags, color: hashtagColor)
            attributedText.changeKeywordsColor(keywords: tweet.urls, color: urlColor)
            attributedText.changeKeywordsColor(keywords: tweet.userMentions, color: userMentionsColor)
            
            tweetTextLabel?.attributedText = attributedText
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOf: profileImageURL as URL) {
                    tweetProfileImageView?.image = UIImage(data: imageData as Data)
                }
            }
            
        }
    }
}

// MARK: - Extensions

private extension NSMutableAttributedString {
    
    func changeKeywordsColor(keywords: [Mention], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}

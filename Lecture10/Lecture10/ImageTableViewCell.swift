//
//  MentionsTableViewCell.swift
//  Lecture10
//
//  Created by Aleksandar Stanojcic on 3/24/17.
//  Copyright © 2017 Aleksandar Stanojcic. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageUrl: NSURL? { didSet { updateUI() } }
    
    //MARK: - Private API
    
    private func updateUI() {
        if let url = imageUrl {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let loadedImageData = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if url == self.imageUrl {
                        if let imageData = loadedImageData {
                            self.tweetImage?.image = UIImage(data: imageData as Data)
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
}

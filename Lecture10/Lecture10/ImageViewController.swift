//
//  ImageViewController.swift
//  Lecture10
//
//  Created by Aleksandar Stanojcic on 3/26/17.
//  Copyright © 2017 Aleksandar Stanojcic. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {
    
    //MARK: - Properties(Public)
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
            spinner?.startAnimating()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        
        didSet {
            scrollView.contentSize  = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Properties(Private)
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize  = imageView.frame.size
            spinner?.stopAnimating()
            scrollViewDidScrollOrZoom = false
            autoScale()
        }
    }
    
    private var scrollViewDidScrollOrZoom = false
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoScale()
    }
    
    //MARK: Private API
    
    private func fetchImage() {
        spinner?.startAnimating()
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { // 1
                let loadedImageData = NSData(contentsOf: url as URL)
                DispatchQueue.main.async { // 2
                    if url == self.imageURL {
                        if let imageData = loadedImageData {
                            self.image = UIImage(data: imageData as Data)
                        } else {
                            self.image = nil
                        }
                        
                    }
                }
            }
        }
        
    }
    
    private func autoScale() {
        if scrollViewDidScrollOrZoom {
            return
        }
        if let sv = scrollView {
            if image != nil {
                sv.zoomScale = max(sv.bounds.size.height / image!.size.height,
                                   sv.bounds.size.width / image!.size.width)
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                                           y: (imageView.frame.size.height - sv.frame.size.height) / 2)
                scrollViewDidScrollOrZoom = false
            }
        }
    }
    
    //MARK: - ScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
}

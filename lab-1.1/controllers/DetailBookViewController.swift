//
//  DetailBookViewController.swift
//  lab-1.1
//
//  Created by Kirill on 11.03.2021.
//

import UIKit

class DetailBookViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorsLabel: UILabel!
    
    @IBOutlet var publisherLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var pagesLabel: UILabel!
    
    var detailImage: String?
    var detailTitle: String?
    var detailSubtitle: String?
    var detailDesc: String?
    var detailAuthors: String?
    var detailPublisher: String?
    var detailPages: String?
    var detailYear: String?
    var detailRating: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (detailImage == "") {
            imageView.image = nil
        } else {
            imageView.image = UIImage(named: detailImage!)
        }
        
        titleLabel.text = detailTitle
        subtitleLabel.text = detailSubtitle
        descLabel.text = detailDesc
        authorsLabel.text = detailAuthors
        publisherLabel.text = detailPublisher
        pagesLabel.text = detailPages
        yearLabel.text = detailYear
        ratingLabel.text = detailRating
    }
}


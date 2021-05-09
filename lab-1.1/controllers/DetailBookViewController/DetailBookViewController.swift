//
//  DetailBookViewController.swift
//  lab-1.1
//
//  Created by Kirill on 05.05.2021.
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
//        if (detailImage == "") {
//            imageView.image = nil
//        } else {
//            imageView.image = UIImage(named: detailImage!)
//        }
        
        titleLabel.attributedText = makeAttributeString("Title: ", detailTitle!)
        subtitleLabel.attributedText =  makeAttributeString("Subtitle: ", detailSubtitle!)
        descLabel.attributedText =  makeAttributeString("Description: ", detailDesc!)
        authorsLabel.attributedText =  makeAttributeString("Authors: ", detailAuthors!)
        publisherLabel.attributedText =  makeAttributeString("Publisher: ", detailPublisher!)
        pagesLabel.attributedText =  makeAttributeString("Pages: ", detailPages!)
        yearLabel.attributedText =  makeAttributeString("Year: ", detailYear!)
        ratingLabel.attributedText =  makeAttributeString("Rating: ", detailRating!)
    }
    
    private func makeAttributeString(_ header: String, _ mainText: String) -> NSMutableAttributedString {
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.gray]
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string: header, attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string: mainText, attributes: attrs2)
        
        attributedString1.append(attributedString2)
        return attributedString1
    }
}

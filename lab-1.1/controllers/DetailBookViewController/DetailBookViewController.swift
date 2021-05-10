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
    
    var isbn: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getBooksDetail(with: isbn!, completion: { data, error in
            let jsonDetail = try? JSONDecoder().decode(DetailedBook.self, from: data!)
                NetworkManager.shared.getImage(with: jsonDetail!.image) { image, error in
                    self.imageView.image = image
            }
            
            self.titleLabel.attributedText = self.makeAttributeString("Title: ", jsonDetail!.title)
            self.subtitleLabel.attributedText = self.makeAttributeString("Subtitle: ", jsonDetail!.subtitle)
            self.descLabel.attributedText = self.makeAttributeString("Description: ", jsonDetail!.desc)
            self.authorsLabel.attributedText = self.makeAttributeString("Authors: ", jsonDetail!.authors)
            self.publisherLabel.attributedText = self.makeAttributeString("Publisher: ", jsonDetail!.publisher)
            self.pagesLabel.attributedText = self.makeAttributeString("Pages: ", jsonDetail!.pages)
            self.yearLabel.attributedText = self.makeAttributeString("Year: ", jsonDetail!.year)
            self.ratingLabel.attributedText = self.makeAttributeString("Rating: ", jsonDetail!.rating)
        })
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

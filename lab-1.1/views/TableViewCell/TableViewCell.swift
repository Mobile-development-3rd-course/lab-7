//
//  TableViewCell.swift
//  lab-1.1
//
//  Created by Kirill on 28.02.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var imageIbl: UIImageView!
    @IBOutlet var titleIbl: UILabel!
    @IBOutlet var subTitleIbl: UILabel!
    @IBOutlet var priceIbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        titleIbl.text = ""
        subTitleIbl.text = ""
        priceIbl.text = ""
        imageIbl.image = nil
    }
    
}

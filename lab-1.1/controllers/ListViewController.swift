//
//  ListViewController.swift
//  lab-1.1
//
//  Created by Kirill on 28.02.2021.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    private let booksLab3 = StorageManager.shared.parseJson(forFile: "BooksList", forType: ".txt")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (booksLab3?.books.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        guard let book = booksLab3?.books[indexPath.row] else {
            return cell
        }
        cell.titleIbl.text = book.title
        cell.subTitleIbl.text = book.subtitle
        cell.priceIbl.text = book.price
        
        let imageName = StorageManager.shared.getImageName(forBook: book)
        if (!imageName.isEmpty){
            cell.imageIbl.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
}


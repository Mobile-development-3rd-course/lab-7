//
//  ListViewController.swift
//  lab-1.1
//
//  Created by Kirill on 28.02.2021.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private var data = StorageManager.shared.parseJson(forFile: "BooksList", forType: ".txt")
    private var books: [Book] = []
    private var filteredBooks: [Book] = []
    
    lazy var searchBarController: UISearchController = {
        let searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.obscuresBackgroundDuringPresentation = false
        
        searchBarController.searchBar.placeholder = " Search books..."
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.isTranslucent = false
        searchBarController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBarController
        searchBarController.searchResultsUpdater = self
        navigationItem.rightBarButtonItem = {
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBook))
        }()
        
        return searchBarController
    }()
    
    @objc private func addBook() {
        let addBookViewController = storyboard?.instantiateViewController(identifier: "AddBookViewController") as! AddBookViewController
        addBookViewController.delegate = self
        navigationController?.pushViewController(addBookViewController, animated: true)
    }
    
    
    private func getData() {
        for book in data?.books ?? [] {
            books.append(book)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        searchBarController.searchBar.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !(searchBarController.searchBar.text?.isEmpty ?? true) {
            return filteredBooks.count
        }
        
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let book: Book
        
        if !(searchBarController.searchBar.text?.isEmpty ?? true) {
            book = filteredBooks[indexPath.row]
        } else {
            book = books[indexPath.row]
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book: Book
        
        if !(searchBarController.searchBar.text?.isEmpty ?? true) {
            book = filteredBooks[indexPath.row]
        } else {
            book = books[indexPath.row]
        }
        
        guard let detailBookByIdentifier = StorageManager.shared.parseDetailBookJson(ForIdentifier: book.isbn13),
              let detailBook = storyboard?.instantiateViewController(identifier: "DetailBookViewController") as? DetailBookViewController else {
            return
        }
        
        navigationController?.pushViewController(detailBook, animated: true)
        
        detailBook.detailImage = detailBookByIdentifier.image
        detailBook.detailTitle = detailBookByIdentifier.title
        detailBook.detailSubtitle = detailBookByIdentifier.subtitle
        detailBook.detailDesc = detailBookByIdentifier.desc
        detailBook.detailAuthors = detailBookByIdentifier.authors
        detailBook.detailPublisher = detailBookByIdentifier.publisher
        detailBook.detailPages = detailBookByIdentifier.pages
        detailBook.detailYear = detailBookByIdentifier.year
        detailBook.detailRating = detailBookByIdentifier.rating
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let book: Book?
            
            if !(searchBarController.searchBar.text?.isEmpty ?? true) {
                book = filteredBooks[indexPath.row]
                filteredBooks.remove(at: indexPath.row)
                guard let index = books.firstIndex(of: book!) else {
                    return
                }
                books.remove(at: index)
            } else {
                books.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

extension ListViewController: UINavigationControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredBooks = books.filter ({
            let searchBarLowercasedText = (searchController.searchBar.searchTextField.text?.lowercased())
            return $0.title.lowercased().contains(searchBarLowercasedText!) ||
                $0.subtitle.lowercased().contains(searchBarLowercasedText!) ||
                $0.isbn13.lowercased().contains(searchBarLowercasedText!) ||
                $0.price.lowercased().contains(searchBarLowercasedText!)
        })
        
        tableView.reloadData()
    }
    
}

extension ListViewController: AddBookDelegate {
    func transferAddedBook(book: Book) {
        books.append(book)
        let indexPath = IndexPath(row: books.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

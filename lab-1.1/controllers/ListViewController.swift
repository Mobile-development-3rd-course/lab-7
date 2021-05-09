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
    
    lazy var booksNotFoundView: UIView = {
        let emptyView = UIView(frame: CGRect(x: tableView.center.x, y: tableView.center.y, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                let emptyLabel = UILabel()
                emptyView.addSubview(emptyLabel)

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        emptyLabel.text = "Books have not found..."
        emptyLabel.textColor = .systemBlue
        return emptyView
    }()
    
    lazy var searchBarController: UISearchController = {
        let searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.obscuresBackgroundDuringPresentation = false
        
        searchBarController.searchBar.placeholder = " Search books..."
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.isTranslucent = false
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.searchTextField.clearButtonMode = .never
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBarController
        searchBarController.searchResultsUpdater = self
        
        navigationItem.rightBarButtonItem = {
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBook))
        }()
        
        return searchBarController
    }()
    
    @objc private func addBook() {
        
        let testViewController = AddBookViewController()
        testViewController.delegate = self

        navigationController?.pushViewController(testViewController, animated: true)
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
            if (filteredBooks.isEmpty) {
                tableView.backgroundView = nil
                tableView.separatorStyle = .none
                booksNotFoundView.center = CGPoint(x: tableView.frame.size.width  / 2,
                                           y: tableView.frame.size.height / 2)
                tableView.addSubview(booksNotFoundView)
            } else {
                
                tableView.separatorStyle = .singleLine
                for subview in self.view.subviews {
                    subview.removeFromSuperview()
                }
               
            }
            
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
        
        guard let detailBookByIdentifier = StorageManager.shared.parseDetailBookJson(ForIdentifier: book.isbn13) else {
            return
        }
        
        let detailBook = DetailBookViewController()
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
            tableView.reloadData()
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.separatorStyle = .singleLine
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        print("Cancel tapped")
    }
}

extension ListViewController: AddBookDelegate {
    func transferAddedBook(book: Book) {
        books.append(book)
        let indexPath = IndexPath(row: books.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

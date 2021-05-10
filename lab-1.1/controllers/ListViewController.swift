//
//  ListViewController.swift
//  lab-1.1
//
//  Created by Kirill on 28.02.2021.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarController.searchBar.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        booksNotFoundView.center = CGPoint(x: tableView.frame.size.width  / 2,
                                           y: tableView.frame.size.height / 2)
        
        if !(searchBarController.searchBar.text?.isEmpty ?? true) {
            if (filteredBooks.isEmpty) {
                tableView.backgroundView = nil
                tableView.separatorStyle = .none
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
        if (filteredBooks.isEmpty) {
            tableView.backgroundView = nil
            tableView.separatorStyle = .none
            tableView.addSubview(booksNotFoundView)
            tableView.reloadData()
        } else {
            if !(searchBarController.searchBar.text?.isEmpty ?? true) {
                book = filteredBooks[indexPath.row]
            } else {
                book = books[indexPath.row]
            }
            
            cell.titleIbl.text = book.title
            cell.subTitleIbl.text = book.subtitle
            cell.priceIbl.text = book.price
            NetworkManager.shared.getImage(with: book.image) { image, error in
                cell.imageIbl.image = image
            }
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
        if (book.isbn13 == "noid" || book.isbn13 == "") {
            print("Can not show detail book because no file on the server.")
        } else {
            let detailBook = DetailBookViewController()
            detailBook.isbn = book.isbn13
            
            self.navigationController?.pushViewController(detailBook, animated: true)
        }
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
        filteredBooks.removeAll()
        
        let searchBarLowercasedText = (searchController.searchBar.searchTextField.text?.lowercased())
        NetworkManager.shared.getBooks(with: searchBarLowercasedText!) { data, error in
            let jsonBooks = try? JSONDecoder().decode(BooksList.self, from: data!)
            jsonBooks?.books.forEach({book in
                if(!self.books.contains(book)) {
                    
                    self.books.append(book)
                }
            })
            
        }
        let spinner = SpinnerViewController()
        
        tableView.addSubview(spinner.view)
        spinner.view.frame = CGRect(x: tableView.center.x, y: tableView.center.y - 100, width: 10, height: 10)
        filteredBooks = books.filter ({
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
            
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

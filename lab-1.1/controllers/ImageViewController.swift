//
//  ImageViewController.swift
//  lab-1.1
//
//  Created by Kirill on 12.04.2021.
//

import UIKit
import SQLite


class ImageViewController: UIViewController{
    var database: Connection!
    let id = Expression<Int>("id")
    let pageURL = Expression<String>("pageURL")
    let type = Expression<String>("type")
    let tags = Expression<String>("tags")
    let previewURL = Expression<String>("previewURL")
    let previewWidth = Expression<Int>("previewWidth")
    let previewHeight = Expression<Int>("previewHeight")
    let webformatURL = Expression<String>("webformatURL")
    let webformatWidth = Expression<Int>("webformatWidth")
    let webformatHeight = Expression<Int>("webformatHeight")
    let largeImageURL = Expression<String>("largeImageURL")
    let imageWidth = Expression<Int>("imageWidth")
    let imageHeight = Expression<Int>("imageHeight")
    let imageSize = Expression<Int>("imageSize")
    let views = Expression<Int>("views")
    let downloads = Expression<Int>("downloads")
    let favorites = Expression<Int>("favorites")
    let likes = Expression<Int>("likes")
    let comments = Expression<Int>("comments")
    let user_id = Expression<Int>("user_id")
    let user = Expression<String>("user")
    let userImageURL = Expression<String>("userImageURL")
    
    var photosTable = Table("photosTable")
    
    var listOfPictures = [UIImage]()
    var collectionView: UICollectionView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let path = Bundle.main.path(forResource: "dbPhotos", ofType: "db")
            let database = try Connection(path!)

            try database.run(photosTable.create(temporary: true) { t in
                t.column(id, primaryKey: true)
                t.column(pageURL)
                t.column(type)
                t.column(tags)
                t.column(previewURL)
                t.column(previewWidth)
                t.column(previewHeight)
                t.column(webformatURL)
                t.column(webformatWidth)
                t.column(webformatHeight)
                t.column(largeImageURL)
                t.column(imageWidth)
                t.column(imageHeight)
                t.column(imageSize)
                t.column(views)
                t.column(downloads)
                t.column(favorites)
                t.column(likes)
                t.column(user_id)
                t.column(user)
                t.column(comments)
                t.column(userImageURL)
            })
            self.database = database
        } catch {
            print(error)
        }
        
        configureCollectionView()
        view.addSubview(collectionView)
        getPhotosFromServer()
        print(listOfPictures)
    }
    @IBAction func addTapped() {
        openPhotos()
        do {
            for photo in try database.prepare(photosTable) {
                print("id: \(photo[id]), pageURL: \(photo[pageURL])")
                // id: 1, email: alice@mac.com, name: Optional("Alice")
            }
        } catch {
            print(error)
        }
    }
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: ImageViewController.createLayout())
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
    }
    
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openPhotos() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            return
        }
        listOfPictures.append(pickedImage)
        collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ImageViewController:UICollectionViewDataSource {
    
    func getPhotosFromServer() {
        let spinner = SpinnerViewController()
        view.addSubview(spinner.view)
        spinner.view.translatesAutoresizingMaskIntoConstraints = false
        spinner.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        spinner.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spinner.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        spinner.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        NetworkManager.shared.getPhotos{ [weak self](data, error) in
            if let data = data {
                let jsonPhotos = try? JSONDecoder().decode(Photos.self, from: data)
                jsonPhotos?.hits.forEach({ photo in
                    let insertPhotos = self!.photosTable.insert(self!.id <- photo.id,
                                                                self!.pageURL <- photo.pageURL,
                                                                self!.type <- photo.type,
                                                                self!.tags <- photo.tags,
                                                                self!.previewURL <- photo.previewURL,
                                                                self!.previewWidth <- photo.previewWidth,
                                                                self!.previewHeight <- photo.previewHeight,
                                                                self!.webformatURL <- photo.webformatURL,
                                                                self!.webformatWidth <- photo.webformatWidth,
                                                                self!.webformatHeight <- photo.webformatHeight,
                                                                self!.largeImageURL <- photo.largeImageURL,
                                                                self!.imageWidth <- photo.imageWidth,
                                                                self!.imageHeight <- photo.imageHeight,
                                                                self!.imageSize <- photo.imageSize,
                                                                self!.views <- photo.views,
                                                                self!.downloads <- photo.downloads,
                                                                self!.favorites <- photo.favorites,
                                                                self!.likes <- photo.likes,
                                                                self!.comments <- photo.comments,
                                                                self!.user_id <- photo.user_id,
                                                                self!.user <- photo.user,
                                                                self!.userImageURL <- photo.userImageURL)
                    do {
                        try self?.database.run(insertPhotos)
                        print("Inserted: ", photo.id)
                    } catch {
                        print(error)
                    }
                    NetworkManager.shared.getImage(with: photo.largeImageURL) { [weak self] (image, error) in
                        spinner.view.removeFromSuperview()
                        spinner.removeFromParent()
                        self!.listOfPictures.append(image!)
                        self?.collectionView.reloadData()
                    }
                    self?.collectionView.reloadData()
                })
            } else {
                print(error!)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        cell.setupCell(image: listOfPictures[indexPath.item])
        
        return cell
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let inset: CGFloat = 1
        let bigItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(3/4), heightDimension: .fractionalHeight(1))
        let bigItem = NSCollectionLayoutItem(layoutSize: bigItemSize)
        bigItem.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let verticalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1) , heightDimension: .fractionalWidth(1))
        let verticalItem = NSCollectionLayoutItem(layoutSize: verticalItemSize)
        verticalItem.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let horizontalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let horizontalItem = NSCollectionLayoutItem(layoutSize: horizontalItemSize)
        horizontalItem.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalWidth(3/4))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize , subitem: verticalItem, count: 3)
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/4))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize , subitem: horizontalItem, count: 4)
        
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/4))
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize , subitems: [verticalGroup, bigItem])
        
        let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: mainGroupSize , subitems: [nestedGroup, horizontalGroup])
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}


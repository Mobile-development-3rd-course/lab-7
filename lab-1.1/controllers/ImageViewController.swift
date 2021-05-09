//
//  ImageViewController.swift
//  lab-1.1
//
//  Created by Kirill on 12.04.2021.
//

import UIKit

class ImageViewController: UIViewController{
    
    var listOfPictures = [UIImage]()
    var listOfPicturesFormServer = [Photo]()
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        view.addSubview(collectionView)
        getPhotosFromServer()
        print(listOfPicturesFormServer)
    }
    @IBAction func addTapped() {
        openPhotos()
        
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
        NetworkManager.shared.getPhotos{ [weak self](data, error) in
            if let data = data {
                let jsonPhotos = try? JSONDecoder().decode(Photos.self, from: data)
                jsonPhotos?.hits.forEach({ photo in
                    NetworkManager.shared.getImage(with: photo.largeImageURL) { [weak self] (image, error) in
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
        print(listOfPictures)
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


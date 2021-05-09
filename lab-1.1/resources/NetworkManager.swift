//
//  NetworkManager.swift
//  lab-1.1
//
//  Created by Kirill on 09.05.2021.
//

import Foundation
import UIKit

protocol NetworkManagerDelegate {
    func getPhotos(completion: @escaping (Data?, Error?) -> Void)
    func getImage(with coverURL: String, completion: @escaping (UIImage?, Error?) -> Void)
}

final class NetworkManager: NSObject, NetworkManagerDelegate, URLSessionDelegate {
    static let shared = NetworkManager()
    
    var datatask:URLSessionTask?
    
    lazy var urlsession: URLSession = {
         let config = URLSessionConfiguration.default
         return URLSession(configuration: config)
     }()
}

extension NetworkManager {

    func getPhotos(completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://pixabay.com/api/?key=19193969-87191e5db266905fe8936d565&q=hot+summer&image_type=photo&per_page=24"
         guard let components = URLComponents(string: urlString), let url = components.url else {return}
         DispatchQueue.global(qos: .background).async { [weak self] in
             self?.datatask = self?.urlsession.dataTask(with: URLRequest(url: url)) { (data, response, error) in
                 guard let httpresponse = response as? HTTPURLResponse,
                       let data = data,
                       httpresponse.statusCode == 200 else {return}
                 DispatchQueue.main.async {
                     completion(data, nil)
                 }
             }
             self?.datatask?.resume()
         }
     }
    
    func getImage(with imageURL: String, completion: @escaping (UIImage?, Error?) -> Void) {
            guard let url = URL(string: imageURL) else {return}
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.datatask = self?.urlsession.downloadTask(with: url) { (tempURL, response, error) in
                    if let tempURL = tempURL,
                       let data = try? Data(contentsOf: tempURL),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completion(image, nil)
                        }
                    } else {
                        completion(nil, error)
                    }
                }
                self?.datatask?.resume()
            }
        }
}



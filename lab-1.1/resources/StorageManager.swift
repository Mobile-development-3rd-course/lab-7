//
//  StorageManager.swift
//  lab-1.1
//
//  Created by Kirill on 26.02.2021.
//

import Foundation


final class StorageManager {
    static let shared = StorageManager()
}

extension StorageManager {
    
    private func readLocalFile(forName name: String, forType type: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: type),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func parseJson (forFile file: String, forType type: String) -> BooksList? {
        let fileContent = readLocalFile(forName: file, forType: type)
        let jsonBooks = try? JSONDecoder().decode(BooksList.self, from: fileContent!)
        
        return jsonBooks
    }
    
    func parseDetailBookJson(ForIdentifier identifier: String) -> DetailedBook? {
        if let fileContent = readLocalFile(forName: identifier, forType: "txt") {
            let jsonBooks = try? JSONDecoder().decode(DetailedBook.self, from: fileContent)
            return jsonBooks
        }
        print("file are not in storage")
        return nil
    }
    
    func getImageName (forBook book: Book) -> String {
        return book.image
    }
    
}


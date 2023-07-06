//
//  UIImageView+asyncLoadImage.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 06.07.2023.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

public enum Result<T> {
    case success(T)
    case failure(Error)
}

final class Networking {
    
    private static func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public static func downloadImage(url: URL, completion: @escaping (Result<Data>) -> Void) {
        Networking.getData(url: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
}

extension UIImageView {
    func asyncLoadImage(urlSting: String, completion: @escaping (() -> Void) = {}) {
        guard let url = URL(string: urlSting) else { return }
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            setImage(imageFromCache as? UIImage)
            completion()
            return
        }

        Networking.downloadImage(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                setImage(UIImage(data: data))
            case .failure:
                setImage(.checkmark)
            }
            completion()
        }
    }
}

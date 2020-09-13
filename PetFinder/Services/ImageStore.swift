//
//  ImageStore.swift
//  LootLogger
//
//  Created by Ali Sajadi on 8/24/20.
//

import UIKit

class ImageStore {
    
    //MARK:- Cache and save images

    let cache = NSCache<NSString,UIImage>()

    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)

        let url = imageURL(forKey: key)

        // Turn image into JPEG data
        if let data = image.jpegData(compressionQuality: 1.0) {
            // Write it to full URL
            try? data.write(to: url)
        }
    }

    //MARK:- fetch images from cache or disk

    func fetchImage(forKey key: String) -> UIImage? {
//        return cache.object(forKey: key as NSString)
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }

        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }

    //MARK:- Delete images from cache and disk

    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)

        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }

    //MARK:- Create URL

    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!

        return documentDirectory.appendingPathComponent(key)
    }
}

//
//  PhotoLikeRepository.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/27/24.
//

import Foundation
import RealmSwift

final class PhotoLikeRepository {
    private let realm = try! Realm()
    private var list: Results<PhotoLikeDTO>
    
    init() {
        self.list = realm.objects(PhotoLikeDTO.self)
        print(realm.configuration.fileURL ?? "")
    }
    
    func savePhotoLike(photo: PhotoCellModel, imageData: Data) {
        self.saveImageToDocument(imageData: imageData, filename: photo.id)
        
        self.createItem(photo: photo)
    }
    
    func removePhotoLike(photo: PhotoCellModel) {
        self.deleteItem(photoId: photo.id)
        self.removeImageFromDocument(filename: photo.id)
    }
    
    func fetchPhotoLikeList() -> [PhotoCellModel] {
        return list.map {
            let filePath = self.loadImageFilePath(filename: $0.photoId)
            return PhotoCellModel.createPhotoCellModel(dto: $0, savedImageFilePath: filePath)
        }
    }
    
}

//MARK: - Repository <-> Local Storage
extension PhotoLikeRepository {
    
    private func createItem(photo: PhotoCellModel) {
        do {
            try realm.write {
                realm.add(PhotoLikeDTO(photo: photo))
            }
        } catch {
            print(error)
        }
    }
    
    private func deleteItem(photoId: String) {
        guard let deletePhoto = self.list.first(where: {
            $0.photoId == photoId
        }) else { return }
        
        do {
            try realm.write {
                realm.delete(deletePhoto)
            }
        } catch {
            print(error)
        }
    }
    
    private func saveImageToDocument(imageData: Data, filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    private func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        let filePath: String
        
        if #available(iOS 16.0, *) {
            filePath = fileURL.path()
        } else {
            filePath = fileURL.path
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
        
    }

    private func loadImageFilePath(filename: String) -> String? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        let filePath: String
        
        if #available(iOS 16.0, *) {
            filePath = fileURL.path()
        } else {
            filePath = fileURL.path
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            return filePath
        } else {
            return nil
        }
    }
}

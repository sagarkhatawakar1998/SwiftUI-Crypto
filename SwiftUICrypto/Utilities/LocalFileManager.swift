//
//  LocalFileManager.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 08/04/23.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    
    private init() {
        
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // crate folder
        createFolderIfNeeded(folderName:  folderName)
        
        //get path for Image
        guard let data = image.pngData(),
        let url = getURLForImage(imageName: imageName, folderName: folderName) else
        { return}
        
        //save image for path
        do {
            try data.write(to: url)
        }
        catch let err {
            print("error saving Imar  \(imageName).   \(err.localizedDescription)")
        }
    }
    
    
    func getImage(imageName: String, folderName: String)  -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName:  folderName),
              FileManager.default.fileExists(atPath: url.pathExtension) else {
            return nil
        }
        return UIImage(contentsOfFile: url.pathExtension)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = geturlForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.pathExtension) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }
            catch let err {
                print(err.localizedDescription)
            }
        }
        
    }
    
    
    
    private func geturlForFolder(folderName: String) -> URL? {
        guard  let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first   else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    
    private func getURLForImage(imageName: String, folderName: String )  -> URL? {
        guard let folderUrl = geturlForFolder(folderName: folderName) else { return nil}
        return folderUrl.appendingPathExtension(imageName + ".png")
    }
}

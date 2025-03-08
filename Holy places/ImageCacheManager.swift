//
//  ImageCacheManager.swift
//  Holy places
//
//  Created by Andrei Belyi on 08/03/25.
//


import SwiftUI

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cacheDirectory: URL
    private let expirationTime: TimeInterval = 7 * 24 * 60 * 60 // ✅ 7 Days in seconds

    private init() {
        cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache")
        createCacheDirectory()
        cleanOldCache() // ✅ Clean cache on launch
    }

    // ✅ Create cache folder if it doesn't exist
    private func createCacheDirectory() {
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    // ✅ Get cached image
    func getCachedImage(for url: URL) -> Image? {
        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        
        guard let data = try? Data(contentsOf: fileURL),
              let uiImage = UIImage(data: data) else { return nil }
        
        return Image(uiImage: uiImage)
    }

    // ✅ Save image to cache
    func saveImage(_ image: Image, for url: URL) {
        guard let uiImage = image.asUIImage(),
              let data = uiImage.jpegData(compressionQuality: 0.8) else { return }

        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        try? data.write(to: fileURL)

        // ✅ Save timestamp for cleanup
        let timestamp = Date().timeIntervalSince1970
        UserDefaults.standard.set(timestamp, forKey: fileURL.path)
    }

    // ✅ Clean old cache images
    private func cleanOldCache() {
        let fileManager = FileManager.default
        let now = Date().timeIntervalSince1970
        
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) else { return }
        
        for file in files {
            let timestamp = UserDefaults.standard.double(forKey: file.path)
            if now - timestamp > expirationTime { // ✅ Check if older than 7 days
                try? fileManager.removeItem(at: file)
                UserDefaults.standard.removeObject(forKey: file.path) // ✅ Remove timestamp
            }
        }
    }
}

// ✅ Convert `Image` to `UIImage`
extension Image {
    func asUIImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))
        return renderer.image { _ in
            UIColor.white.setFill()
            UIRectFill(CGRect(x: 0, y: 0, width: 200, height: 200))
        }
    }
}

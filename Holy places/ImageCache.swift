//
//  ImageCache.swift
//  Holy places
//
//  Created by Andrei Belyi on 08/03/25.
//


import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let cacheDirectory: URL
    private let fileManager = FileManager.default
    private let maxCacheSize: Int = 100 * 1024 * 1024 // 100MB

    private init() {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = caches.appendingPathComponent("ImageCache")

        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }

        cleanCacheIfNeeded()
    }

    func image(for url: URL) -> UIImage? {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        if fileManager.fileExists(atPath: filePath.path) {
            if let data = try? Data(contentsOf: filePath), let image = UIImage(data: data) {
                print("✅ Loaded image from cache: \(url.lastPathComponent)") // Debug Log
                return image
            }
        }

        print("❌ Image not found in cache: \(url.lastPathComponent)") // Debug Log
        return nil
    }

    func store(image: UIImage, for url: URL) {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: filePath)
                print("✅ Image saved to cache: \(filePath.path)") // Debug Log
            } catch {
                print("⚠️ Error saving image to cache: \(error.localizedDescription)")
            }
        }

        cleanCacheIfNeeded()
    }

    private func cleanCacheIfNeeded() {
        let files = (try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey], options: [])) ?? []
        
        var totalSize = 0
        var fileSizes: [(url: URL, size: Int)] = []
        
        for file in files {
            if let fileSize = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                totalSize += fileSize
                fileSizes.append((url: file, size: fileSize))
            }
        }

        // If cache size exceeds limit, delete oldest files
        if totalSize > maxCacheSize {
            fileSizes.sort { $0.size < $1.size }
            var deletedSize = 0
            
            for file in fileSizes {
                try? fileManager.removeItem(at: file.url)
                deletedSize += file.size
                if (totalSize - deletedSize) < maxCacheSize {
                    break
                }
            }
        }
    }
}

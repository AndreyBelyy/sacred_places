//
//  CachedAsyncImage.swift
//  Holy places
//
//  Created by Andrei Belyi on 08/03/25.
//


import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity) // ✅ Smooth transition
                case .failure:
                    Image(systemName: "photo") // ✅ Placeholder if the image fails
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                default:
                    ProgressView() // ✅ Show loading indicator
                }
            }
        } else {
            Image(systemName: "photo") // ✅ Placeholder for missing URL
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
        }
    }
}
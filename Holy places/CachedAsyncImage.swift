import SwiftUI
import Foundation

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let placeholder: () -> Placeholder
    private let image: (Image) -> Content

    @State private var cachedImage: UIImage?

    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> Content
    ) {
        self.url = url
        self.placeholder = placeholder
        self.image = image
    }

    var body: some View {
        if let uiImage = cachedImage {
            image(Image(uiImage: uiImage))
        } else {
            placeholder()
                .onAppear {
                    loadImage()
                }
        }
    }

    private func loadImage() {
        guard let url = url else { return }

        if let cachedImage = ImageCache.shared.image(for: url) {
            self.cachedImage = cachedImage
        } else {
            downloadImage(from: url)
        }
    }

    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.cachedImage = uiImage
            }
            
            ImageCache.shared.store(image: uiImage, for: url)
        }.resume()
    }
}

import SwiftUI

struct SplashScreenView: View {
    @Binding var showSplash: Bool  // ✅ Controls when to hide splash
    @State private var imageOpacity = 0.0
    @State private var scaleEffect = 1.2  // Start slightly zoomed in

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // ✅ Background color to match theme
            
            // 🎨 **Animated Image Reveal**
            AsyncImage(url: URL(string: "https://cdn.azbyka.ru/art/wp-content/uploads/2023/06/nt-220-the-angel-and-women-at-the-empty-tomb.jpg")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(imageOpacity)
                        .scaleEffect(scaleEffect)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2.0)) {
                                imageOpacity = 1.0
                                scaleEffect = 1.0  // ✅ Gradually zooms in for cinematic effect
                            }
                        }
                } else {
                    // 🌟 **Custom Animated Loading Indicator**
                    VStack {
                        Text("Loading...")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.bottom, 10)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)  // Bigger loading icon
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) { // ✅ Show for 7s
                withAnimation {
                    showSplash = false  // ✅ Transition to main app
                }
            }
        }
    }
}

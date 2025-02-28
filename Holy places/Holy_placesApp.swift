import SwiftUI

@main
struct Holy_placesApp: App {
    @State private var showSplash = true  // ✅ Track splash visibility

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView(showSplash: $showSplash)  // ✅ Show splash first
            } else {
                MainTabView()  // ✅ Load main app after splash
            }
        }
    }
}

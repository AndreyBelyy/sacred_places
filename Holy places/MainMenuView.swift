import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Holy Places")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    
                    NavigationLink(destination: ContentView()) {  // ✅ Go to Countries first
                        MenuCard(title: "Places", icon: "list.bullet")
                    }
                    
                    NavigationLink(destination: MapView()) {
                        MenuCard(title: "Map", icon: "map.fill")
                    }
                    
                    NavigationLink(destination: NearbyPlacesView()) {
                        MenuCard(title: "Nearby", icon: "location.circle.fill")
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
// 🔹 Custom Menu Card Component
struct MenuCard: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 150)
        .background(Color.blue)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

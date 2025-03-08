import SwiftUI

struct PlacePreviewCard: View {
    let place: Place
    @Binding var isPresented: Bool
    var onViewDetails: () -> Void  // ✅ Callback to trigger navigation

    var body: some View {
        VStack {
            // ✅ Use Cached Image to Avoid Re-Loading
            CachedAsyncImage(url: place.imageURL)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 15))

            Text(place.name)
                .font(.headline)

            Text(place.category.localizedName)
                .font(.subheadline)
                .foregroundColor(.gray)

            Button(action: {
                isPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onViewDetails() // ✅ Call parent function to handle navigation
                }
            }) {
                Text("View Details")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}


import SwiftUI

struct LightGuideView: View {

    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                    Text("Learn how natural light can transform your photography.")
                        .foregroundStyle(.secondary)
                    
                    guideLink(
                        title: "Golden Hour",
                        subtitle: "Warm light and long shadows",
                        icon: "sun.max.fill",
                        color: .orange
                    )
                    
                    guideLink(
                        title: "Blue Hour",
                        subtitle: "Cool tones and atmospheric light",
                        icon: "moon.stars.fill",
                        color: .blue
                    )
                    
                    guideLink(
                        title: "Sunrise, Sunset & Twilight",
                        subtitle: "Understand the changing light",
                        icon: "sunrise.fill",
                        color: .orange
                    )
                    
                    guideLink(
                        title: "Polar Light & Seasons",
                        subtitle: "Discover how daylight changes",
                        icon: "globe.europe.africa.fill",
                        color: .cyan
                    )
                    
                    guideLink(
                        title: "Weather & Lighting",
                        subtitle: "How weather affects photography",
                        icon: "cloud.sun.fill",
                        color: .gray
                    )
                    
                    guideLink(
                        title: "Photography Tips",
                        subtitle: "Make the most of natural light",
                        icon: "camera.fill",
                        color: .purple
                    )
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Light Guide")
            
            .scrollContentBackground(.hidden)
            
            // Her ønsket jeg en svak oransje tone i Light Guide, men oppdaget at
            // bakgrunnen gjorde teksten vanskelig å lese i Dark Mode.
            // Derfor bruker jeg systembakgrunnen og legger til litt oransje.
            .background {
                Color(uiColor: .systemBackground)
                    .overlay(Color.orange.opacity(0.05))
                    .ignoresSafeArea()
            }


        }
    }

    // Lager en klikkbar rad som åpner riktig informasjonsside.
    private func guideLink(
        title: String,
        subtitle: String,
        icon: String,
        color: Color
    ) -> some View {

        NavigationLink {
            LightGuideDetailView(title: title)
        } label: {
            HStack(spacing: 14) {

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    LightGuideView()
}


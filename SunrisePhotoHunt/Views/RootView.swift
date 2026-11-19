
import SwiftUI

struct RootView: View {

    var body: some View {
        TabView {

            Tab("Map", systemImage: "map") {
                MapView()
            }

            Tab("My Spots", systemImage: "mappin.and.ellipse") {
                MySpotsView()
            }

            Tab("My Gallery", systemImage: "photo.on.rectangle") {
                PhotoGalleryView()
            }
            
            Tab("Light Guide", systemImage: "book.closed") {
                LightGuideView()
            }
        }
    }
}



import SwiftUI

struct LightGuideDetailView: View {

    let title: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text(title)
                    .font(.largeTitle.bold())

                
               
                if title == "Golden Hour" {

                    // Viser et eksempel på varmt lys under Golden Hour.
                    Image("GoldenHour")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("What is Golden Hour?")
                        .font(.title2.bold())

                    Text("Golden Hour is the period around sunrise and sunset when the sun is close to the horizon. The light often appears warm and soft, creating beautiful colors and long shadows.")

                    Divider()

                    Text("Why Does the Light Look Golden?")
                        .font(.title2.bold())

                    Text("When the sun is low, sunlight travels through more of Earth's atmosphere. More blue light is scattered, allowing warmer orange and red tones to become more noticeable.")

                    Divider()

                    Text("When Does It Happen?")
                        .font(.title2.bold())

                    Text("Golden Hour occurs around sunrise and sunset. Its duration depends on the season and your location. In northern regions, it can last several hours because the sun moves slowly across the horizon.")

                    Divider()

                    Text("Why Is It Popular for Photography?")
                        .font(.title2.bold())

                    Text("The warm light, softer contrast and long shadows can add depth and atmosphere to photographs. It is especially popular for landscapes, nature and portraits.")

                
                } else if title == "Blue Hour" {

                    // Viser et eksempel på blått lys under Blue Hour.
                    Image("BlueHour")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("What Is Blue Hour?")
                        .font(.title2.bold())

                    Text("Blue Hour is a period of twilight when the sun is below the horizon, but the sky still receives indirect sunlight. The light often takes on beautiful blue tones, creating a calm and atmospheric mood.")

                    Divider()

                    Text("Why Does the Sky Look Blue?")
                        .font(.title2.bold())

                    Text("After sunset and before sunrise, direct sunlight no longer reaches the ground. However, sunlight still illuminates the upper atmosphere. Scattered light can give the sky its characteristic deep blue appearance.")

                    Divider()

                    Text("When Does It Happen?")
                        .font(.title2.bold())

                    Text("Blue Hour usually occurs before sunrise and after sunset. Despite its name, it often lasts much less than an hour. Its duration depends on your location and the time of year.")

                    Divider()

                    Text("Why Is It Popular for Photography?")
                        .font(.title2.bold())

                    Text("The cool blue sky creates a beautiful contrast with warm artificial lights. Blue Hour is especially popular for cityscapes, architecture, reflections in water and atmospheric landscape photography.")

                
                } else if title == "Sunrise, Sunset & Twilight" {

                    // Viser et eksempel med solnedgang bilde.
                    Image("SunriseSunset")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Photography Around Sunrise & Sunset")
                        .font(.title2.bold())

                    Text("The most interesting light often appears before sunrise and continues after sunset. Colors, shadows and contrast change quickly during these periods, making them especially rewarding for photography. Arriving early and staying a little longer can help you capture these changing conditions.")

                    Text("Sunset occurs when the sun's upper edge disappears below the horizon. However, the sky does not become dark immediately. Colors and atmospheric light can remain visible long after sunset.")

                    Divider()

                    Text("What Is Twilight?")
                        .font(.title2.bold())

                    Text("Twilight is the period before sunrise and after sunset when the sun is below the horizon but still illuminates the sky. It is divided into three stages based on how far the sun is below the horizon.")

                    Divider()

                    Text("The Three Stages of Twilight")
                        .font(.title2.bold())

                    Text("Civil Twilight")
                        .font(.headline)

                    Text("The brightest stage of twilight. There is often enough natural light to see the landscape clearly, and the sky can display beautiful colors.")

                    Text("Nautical Twilight")
                        .font(.headline)

                    Text("The sky becomes darker, and the horizon is harder to distinguish. More stars become visible as natural light fades.")

                    Text("Astronomical Twilight")
                        .font(.headline)

                    Text("The darkest stage of twilight. Only a small amount of sunlight remains in the sky. Once astronomical twilight ends, the sky reaches astronomical night.")

                    Divider()

                    Text("Why Does It Matter for Photography?")
                        .font(.title2.bold())

                    Text("Some of the most interesting lighting conditions happen before sunrise and after sunset. Understanding twilight helps photographers plan for changing colors, silhouettes, reflections and low-light photography.")

                
                } else if title == "Polar Light & Seasons" {

                    Text("Why Does Daylight Change?")
                        .font(.title2.bold())

                    Text("The amount of daylight changes throughout the year because Earth's axis is tilted. The farther north or south you travel, the more extreme these seasonal changes become.")

                    Divider()

                    // Viser hvordan mørketiden kan se ut.
                    Image("PolarNight")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Polar Night")
                        .font(.title2.bold())

                    Text("During Polar Night, the sun stays below the horizon throughout the day. However, this does not always mean complete darkness. When the sun is close enough to the horizon, beautiful blue and purple twilight can still illuminate the landscape.")

                    Divider()

                    // Viser midnattssolen om sommeren.
                    Image("MidnightSun")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Midnight Sun")
                        .font(.title2.bold())

                    Text("During the Midnight Sun, the sun remains above the horizon for 24 hours or longer. In northern Norway, this happens during parts of the summer. The low sun can create warm, golden light even late at night.")

                    Divider()

                    Text("How Does This Affect Photography?")
                        .font(.title2.bold())

                    Text("At high latitudes, the sun moves across the horizon at a shallow angle. This can make Golden Hour and Blue Hour last much longer than usual. During Polar Night or the Midnight Sun, some sunrise and sunset times may not exist at all.")

                    Text("Sunrise Photo Hunt displays these periods based on the location and date you choose.")

                
                } else if title == "Weather & Lighting" {

                    
                    Image("ClearSkyies")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Clear Skies & Direct Sunlight")
                        .font(.title2.bold())

                    Text("Clear skies allow direct sunlight to reach the landscape, creating strong contrasts and defined shadows. When the sun is low, the light often becomes warmer and softer, making sunrise and sunset especially attractive for photography.")

                    Divider()

                    // Viser hvordan skyer kan skape dramatiske farger.
                    Image("CloudySunset")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Clouds & Sunset Colors")
                        .font(.title2.bold())

                    Text("Clouds can create dramatic colors around sunrise and sunset. When sunlight passes through gaps in the clouds, the sky may glow with warm orange and golden tones. Thick cloud cover, however, can hide the sun completely.")

                    Divider()

                    // Viser hvordan tåke påvirker landskapsfotografering.
                    Image("FogSunrise")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Fog & Mist")
                        .font(.title2.bold())

                    Text("Fog and mist can transform familiar landscapes into atmospheric scenes. They soften distant objects, reduce contrast and create a sense of depth. Early mornings are often a good time to look for mist, especially near lakes and forests.")

                    Divider()

                    // Viser solstråler som slipper gjennom skyene.
                    Image("SunBlockbyclouds")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Changing Weather & Light")
                        .font(.title2.bold())

                    Text("Weather conditions can change the appearance of natural light within minutes. When sunlight breaks through clouds, dramatic rays of light can illuminate parts of the landscape. These moments can create unique photography opportunities.")

                    Divider()

                    Text("Planning Your Photography")
                        .font(.title2.bold())

                    Text("Sunrise Photo Hunt shows when natural light periods occur, but it does not predict the weather. Check the forecast before heading out, and remember that cloudy or rainy conditions can also produce beautiful photographs.")

                } else if title == "Photography Tips" {
                    
                    
                    Image("PhotographyTips")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))


                    guideTip(
                        icon: "clock",
                        title: "Arrive Early",
                        description: "Arrive before the best light begins. Give yourself time to explore the location and prepare your camera."
                    )

                    guideTip(
                        icon: "sun.max",
                        title: "Follow the Light",
                        description: "Pay attention to the direction of sunlight. Front lighting, side lighting and backlighting create different effects."
                    )

                    guideTip(
                        icon: "camera",
                        title: "Use a Tripod",
                        description: "During Blue Hour, a tripod can help you capture sharp photographs when longer exposures are needed."
                    )

                    guideTip(
                        icon: "water.waves",
                        title: "Look for Reflections",
                        description: "Lakes, puddles and wet surfaces can create beautiful reflections of the sky and surrounding landscape."
                    )

                    guideTip(
                        icon: "viewfinder",
                        title: "Experiment with Composition",
                        description: "Try different angles and perspectives. Including objects in the foreground can add depth to your photographs."
                    )

                    guideTip(
                        icon: "moon.stars",
                        title: "Stay After Sunset",
                        description: "Don't pack away your camera when the sun disappears. Twilight can produce beautiful colors and atmospheric light."
                    )

                } else {
                    Text(explanation)
                        .font(.body)
                }


                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        // Bruker systembakgrunn som tilpasser seg Light og Dark Mode.
        .background {
            Color(uiColor: .systemBackground)
                .overlay(Color.orange.opacity(0.05))
                .ignoresSafeArea()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Forklarer det valgte temaet.
    private var explanation: String {
        switch title {

        case "Golden Hour":
            return "Golden Hour is the period around sunrise and sunset when the sun is low in the sky. The light often becomes warmer and softer, creating beautiful colors and long shadows. It is especially popular for landscape, nature and portrait photography. Despite its name, Golden Hour does not always last exactly one hour."

        case "Blue Hour":
            return "Blue Hour occurs during twilight, when the sun is below the horizon but still illuminates the sky. The light often takes on cool blue tones, creating a calm and atmospheric appearance. It happens before sunrise and after sunset, and may last much less than an hour."

        case "Sunrise, Sunset & Twilight":
            return "Sunrise is the moment the sun first appears above the horizon, while sunset is when it disappears below it. Twilight is the period when the sun is below the horizon but the sky still receives sunlight. This explains why it can be light before sunrise and after sunset."

        case "Polar Light & Seasons":
            return "The duration of daylight changes throughout the year and depends on your location. In northern regions, Golden Hour can last several hours when the sun stays low in the sky. During Polar Night the sun does not rise above the horizon, while during the Midnight Sun it remains above the horizon throughout the day."

        case "Weather & Lighting":
            return "Weather has a major influence on natural light. Clouds can soften harsh sunlight, while gaps in the clouds may create dramatic rays and colors. Fog can give photographs a soft and mysterious atmosphere. Even when the timing is perfect, the actual lighting depends on the weather."

        case "Photography Tips":
            return "Planning ahead can make a big difference in outdoor photography. Understanding sunlight, weather and location helps you prepare for the conditions you want. Sunrise Photo Hunt helps you discover and save locations and check their natural light periods."

        default:
            return ""
        }
    }
    
    
    // Lager en rad med ikon, overskrift og forklaring.
    private func guideTip(
        icon: String,
        title: String,
        description: String
    ) -> some View {

        HStack(alignment: .top, spacing: 14) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.headline)

                Text(description)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }


}

#Preview {
    NavigationStack {
        LightGuideDetailView(title: "Polar Light & Seasons")
        // Alle sidene: "Golden Hour", "Blue Hour", "Sunrise, Sunset & Twilight", "Polar Light & Seasons"
    }
}


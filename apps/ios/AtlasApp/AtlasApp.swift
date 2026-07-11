import SwiftUI

@main
struct AtlasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                List {
                    Section {
                        Label("Import IPA", systemImage: "square.and.arrow.down")
                        Label("Refresh Apps", systemImage: "arrow.clockwise")
                        Label("Browse Sources", systemImage: "square.grid.2x2")
                    } header: {
                        Text("Atlas")
                    } footer: {
                        Text("This build is an unsigned physical-device IPA produced with the iOS 26 SDK. Sign it with your own certificate and matching provisioning profile before installation.")
                    }
                }
                .navigationTitle("Atlas")
            }
            .tabItem { Label("Apps", systemImage: "square.stack.3d.up") }
            .tag(0)

            NavigationStack {
                List {
                    LabeledContent("Runtime", value: "Device")
                    LabeledContent("Architecture", value: "arm64")
                    LabeledContent("Signing", value: "Unsigned")
                    LabeledContent("Transport", value: "LocalDevVPN + minimuxer")
                }
                .navigationTitle("Status")
            }
            .tabItem { Label("Status", systemImage: "waveform.path.ecg") }
            .tag(1)
        }
    }
}

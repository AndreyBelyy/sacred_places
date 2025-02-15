//
//  SettingsView.swift
//  Map of Holy places
//
//  Created by Andrei Belyi on 14/02/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appLanguage") private var appLanguage: String = Locale.current.languageCode ?? "en"
    
    var body: some View {
        Form {
            Section(header: Text("Language")) {
                Picker("Language", selection: $appLanguage) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                    Text("Español").tag("es")
                }
                .pickerStyle(.segmented)
                .onChange(of: appLanguage) { _ in
                    changeAppLanguage()
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    private func changeAppLanguage() {
        UserDefaults.standard.set([appLanguage], forKey: "AppleLanguages")
        exit(0) // Restart app to apply changes
    }
}

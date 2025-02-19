//
//  MainTabView.swift
//  Holy places
//
//  Created by Andrei Belyi on 14/02/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Explore")
                }
            
            MapExploreView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}
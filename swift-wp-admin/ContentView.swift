//
//  ContentView.swift
//  swift-wp-admin
//
//  Created by Pavel on 13.03.2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        NavigationView {
            WpSidebar()
            DetailView()
        }
    }
}

struct WpSidebar: View {
    @State private var isDashboardExpanded = false
    
    var body: some View {
        List {
            DisclosureGroup(isExpanded: $isDashboardExpanded) {
                NavigationLink(destination: DetailView(text: "Dashboard")) {
                    Text("Home")
                }
                NavigationLink(destination: DetailView(text: "Updates")) {
                    Text("Updates")
                }
            } label: {
                Label {
                    Text(   "Dashboard" )
                } icon: {
                    Image("dashboard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Posts")) {
                Label {
                    Text("Posts")
                } icon: {
                    Image("admin-post")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Media")) {
                Label {
                    Text("Media")
                } icon: {
                    Image("admin-media")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Pages")) {
                Label {
                    Text("Pages")
                } icon: {
                    Image("admin-page")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Comments")) {
                Label {
                    Text("Comments")
                } icon: {
                    Image("admin-comments")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Appearance")) {
                Label {
                    Text("Appearance")
                } icon: {
                    Image("admin-appearance")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Plugins")) {
                Label {
                    Text("Plugins")
                } icon: {
                    Image("admin-plugins")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Users")) {
                Label {
                    Text("Users")
                } icon: {
                    Image("admin-users")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Tools")) {
                Label {
                    Text("Tools")
                } icon: {
                    Image("admin-tools")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: DetailView(text: "Settings")) {
                Label {
                    Text("Settings")
                } icon: {
                    Image("admin-settings")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Menu")
    }
}

struct DetailView: View {
    var text: String = "Welcome"
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}


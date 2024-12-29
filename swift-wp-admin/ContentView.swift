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
                    Text("Dashboard")
                } icon: {
                    Image("dashboard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            
            NavigationLink(destination: PostsTableView()) {
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

struct PostsTableView: View {
    @State private var posts: [Post] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Text("Posts")
                .font(.largeTitle)
                .padding()
            
            if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Table(posts) {
                    TableColumn("Title", value: \.title)
                    TableColumn("Author", value: \.author)
                    TableColumn("Categories", value: \.categories)
                    TableColumn("Date", value: \.formattedDate)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
        .onAppear {
            fetchPosts()
        }
    }
    
    private func fetchPosts() {
        guard let url = URL(string: "https://health.developer-pro.com/wp-json/wp/v2/posts") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received"
                    isLoading = false
                    return
                }
                
                do {
                    let apiPosts = try JSONDecoder().decode([APIPost].self, from: data)
                    let group = DispatchGroup()
                    
                    var fetchedPosts: [Post] = []
                    
                    for apiPost in apiPosts {
                        group.enter()
                        
                        fetchAuthorName(authorID: apiPost.author) { authorName in
                            fetchCategoryNames(categoryIDs: apiPost.categories) { categoryNames in
                                let post = Post(
                                    title: apiPost.title.rendered,
                                    author: authorName ?? "Unknown Author",
                                    categories: categoryNames.joined(separator: ", "),
                                    date: apiPost.date
                                )
                                fetchedPosts.append(post)
                                group.leave()
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self.posts = fetchedPosts
                        self.isLoading = false
                    }
                    
                } catch {
                    errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }.resume()
    }
    
    private func fetchAuthorName(authorID: Int, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://health.developer-pro.com/wp-json/wp/v2/users/\(authorID)")
        guard let url = url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching author: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received for author")
                completion(nil)
                return
            }
            
            do {
                let author = try JSONDecoder().decode(APIUser.self, from: data)
                completion(author.name)
            } catch {
                print("Failed to decode author JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchCategoryNames(categoryIDs: [Int], completion: @escaping ([String]) -> Void) {
        let group = DispatchGroup()
        var categoryNames: [String] = []
        
        for categoryID in categoryIDs {
            group.enter()
            
            let url = URL(string: "https://health.developer-pro.com/wp-json/wp/v2/categories/\(categoryID)")
            guard let url = url else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching category: \(error.localizedDescription)")
                    group.leave()
                    return
                }
                
                guard let data = data else {
                    print("No data received for category")
                    group.leave()
                    return
                }
                
                do {
                    let category = try JSONDecoder().decode(APICategory.self, from: data)
                    categoryNames.append(category.name)
                    group.leave()
                } catch {
                    print("Failed to decode category JSON: \(error.localizedDescription)")
                    group.leave()
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            completion(categoryNames)
        }
    }
}

// MARK: - Models

struct APIPost: Decodable {
    let id: Int
    let date: String
    let title: Rendered
    let author: Int
    let categories: [Int]
    
    struct Rendered: Decodable {
        let rendered: String
    }
}

struct APIUser: Decodable {
    let id: Int
    let name: String
}

struct APICategory: Decodable {
    let id: Int
    let name: String
}

struct Post: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let categories: String
    let date: String
    
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Adjusted format to match the input
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC") // Ensures parsing as UTC
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy/MM/dd 'at' h:mm a"
        outputFormatter.amSymbol = "am"
        outputFormatter.pmSymbol = "pm"
        
        if let date = inputFormatter.date(from: self.date) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

//
//  SwiftUIView.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 28/01/24.
//

import SwiftUI

struct ForumPost: Identifiable, Codable {
    let id = UUID()
    var content: String
    var date: Date
    var userName: String
    // Adicione a foto do usuário se necessário
}

class ForumViewModel: ObservableObject {
    
    @Published var posts: [ForumPost] = []
    
    init() {
        loadPosts()
    }
    
    func addPost(_ post: ForumPost) {
        posts.insert(post, at: 0) // Adiciona no início para simular um feed
        savePosts()
    }

    func deletePost(at offsets: IndexSet) {
        posts.remove(atOffsets: offsets)
        savePosts()
    }

    func savePosts() {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: "forumPosts")
        }
    }

    func loadPosts() {
        if let data = UserDefaults.standard.data(forKey: "forumPosts"),
           let decoded = try? JSONDecoder().decode([ForumPost].self, from: data) {
            posts = decoded
        }
    }
}

struct ForumView: View {
    @StateObject private var viewModel = ForumViewModel()
    @State private var newPostContent: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("FORUM")
                    .font(.largeTitle)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5) 
                    )
                
                List {
                    ForEach(viewModel.posts) { post in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(post.userName)
                                .font(.headline)
                            Text(post.content)
                            Text(post.date, style: .date)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding([.horizontal, .bottom], 10)
                        .onTapGesture {
                        }
                    }
                    .onDelete(perform: viewModel.deletePost)
                }
                .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
                
                Spacer()
                
                VStack {
                    TextField("Escreva seu post aqui...", text: $newPostContent)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Postar") {
                        let newPost = ForumPost(content: newPostContent, date: Date(), userName: "Usuário \(Int.random(in: 1...100))")
                        viewModel.addPost(newPost)
                        newPostContent = ""
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .shadow(radius: 3)
                Spacer()
            }
            .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
            .navigationBarHidden(true)
            .onAppear(perform: {
                viewModel.loadPosts()
            })
        }
    }
}

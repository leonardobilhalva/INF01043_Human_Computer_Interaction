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
    @AppStorage("forumPosts") private var postsData: Data = Data()

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

    private func savePosts() {
        if let encoded = try? JSONEncoder().encode(posts) {
            postsData = encoded
        }
    }

    private func loadPosts() {
        if let decoded = try? JSONDecoder().decode([ForumPost].self, from: postsData) {
            posts = decoded
        }
    }
}

struct ForumView: View {
    @StateObject private var viewModel = ForumViewModel()
    @State private var newPostContent: String = ""

    var body: some View {
        VStack {
            Text("FORUM").font(.largeTitle).padding()
            
            TextField("Escreva seu post aqui...", text: $newPostContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Postar") {
                let newPost = ForumPost(content: newPostContent, date: Date(), userName: "Usuário \(Int.random(in: 1...100))")
                viewModel.addPost(newPost)
                newPostContent = "" // Limpar o campo após postar
            }
            
            ScrollView {
                ForEach(viewModel.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.userName).fontWeight(.bold)
                        Text(post.content)
                        Text(post.date, style: .date)
                        Divider()
                    }
                    .padding()
                }
                .onDelete(perform: viewModel.deletePost)
            }
        }
    }
}

//
//  Home.swift
//  DoubleSliderView
//
//  Created by Sopnil Sohan on 11/10/21.
//

import SwiftUI

struct Home: View {
    
    @State var posts: [Post] = []
    //Current Image...
    @State var currentPosts: String = ""
    
    @State var fullPreview: Bool = false
    
    var body: some View {
        
        //Double side Gallary....
        TabView(selection: $currentPosts) {
            ForEach(posts) {post in
                
                //For Getting Size for Image....
                GeometryReader {proxy in
                    
                    let size = proxy.size
                    
                    Image(post.postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(0)
                }
                .tag(post.id)
                .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation {
                fullPreview.toggle()
            }
        }
        //Bottom Image View...
        .overlay(
            //ScrollView reader to navigate To current  Image...
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(posts) {post in
                            Image(post.postImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 60)
                                .cornerRadius(12)
                            //showing ring for current post...
                                .padding(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(Color.white,lineWidth: 2)
                                        .opacity(currentPosts == post.id ? 1 : 0)
                                )
                                .id(post.id)
                                .onTapGesture {
                                    withAnimation {
                                        currentPosts = post.id
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .frame(height: 80)
                .background(Color.white.opacity(0.55).ignoresSafeArea())
                //while currentPost Changing moving the current image view to center of scrollview...
                .onChange(of: currentPosts) { _ in
                    proxy.scrollTo(currentPosts, anchor: .bottom)
                }
            },
            alignment: .bottom
        )
        //Inserting Sample Post Images....
        .onAppear {
            for index in 1...5 {
                posts.append(Post(postImage: "post\(index)"))
            }
            currentPosts = posts.first?.id ?? ""
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

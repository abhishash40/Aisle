//
//  ThirdScreen.swift
//  AisleApp
//
//  Created by Abhishek on 06/11/24.
//

import SwiftUI

struct ThirdScreen: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        List {
            if let likes = viewModel.notes.likes {
                Section(header: Text("Likes")) {
                    ForEach(likes.profiles ?? [], id: \.firstName) { profile in
                        HStack {
                            AsyncImage(url: URL(string: profile.avatar ?? "")) { image in
                                image.resizable().scaledToFit().frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                            }
                            Text(profile.firstName ?? "Unknown")
                        }
                    }
                }
                Text("Total Likes Received: \(String(describing: viewModel.notes.likes?.profiles?.count ?? 0))")
            }
        }
    }
}

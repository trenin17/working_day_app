//
//  VacationAsyncImage.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 4/19/23.
//

import SwiftUI

struct VacationAsyncImage: View {
    private var defaultImage: () -> AnyView = {
        IconAsset.avatarPlaceholder
            .resizable()
            .aspectRatio(contentMode: .fill)
            .eraseToAnyView()
    }
    private var url: String?
    
    init(url: String?) {
        self.url = url
    }
    
    var body: some View {
        if let url = url {
            AsyncImage(
                url: URL(string: url),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                }
            )
        } else {
            defaultImage()
        }
    }
    
    func defaultImage(@ViewBuilder _ image: @escaping () -> Image) -> VacationAsyncImage {
        var copy = self
        copy.defaultImage = {
            image()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .eraseToAnyView()
        }
        return copy
    }
    
    func defaultImage<V: View>(@ViewBuilder _ image: @escaping () -> V) -> VacationAsyncImage {
        var copy = self
        copy.defaultImage = { image().eraseToAnyView() }
        return copy
    }
}

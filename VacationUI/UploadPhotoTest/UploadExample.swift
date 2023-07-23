//
//  UploadExample.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 5/10/23.
//

import SwiftUI
import Combine

class UploadExampleStore: ObservableObject {
    @Published var image: Image?
    
    init() {
        image = nil
    }
    
    func uploadImage(image: Image) {
        self.image = image
    }
}

struct UploadExample: View {
    
    @ObservedObject var store = UploadExampleStore()
    
    var body: some View {
        VStack {
            if let image = store.image {
                image
            } else {
                Text("No image yet")
            }
            Spacer()
            Button("UploadImage") {
                let image = IconAsset.avatarPlaceholder
                store.uploadImage(image: image)
            }
        }
    }
}

struct UploadExample_Previews: PreviewProvider {
    static var previews: some View {
        UploadExample()
    }
}

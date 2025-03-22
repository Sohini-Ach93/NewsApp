//
//  ImageLoader.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: Image? = nil

    func load(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = Image("Placeholder")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            } else {
                DispatchQueue.main.async {
                    self.image = Image("Placeholder")
                }
            }
        }.resume()
    }
}

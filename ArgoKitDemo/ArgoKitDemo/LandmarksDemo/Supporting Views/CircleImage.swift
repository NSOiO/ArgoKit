/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that clips an image to a circle and adds a stroke and shadow.
*/

import ArgoKit

class CircleImage: View {
    
    var image: Image
    init(image: Image) {
        self.image = image
    }
    var body: View {
        image.cornerRadius(image.imageSize().width * 0.5)
//        image
//            .clipShape(Circle())
//            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//            .shadow(radius: 10)
    }
}

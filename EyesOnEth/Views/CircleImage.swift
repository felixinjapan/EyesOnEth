/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that clips an image to a circle and adds a stroke and shadow.
*/

import SwiftUI

struct CircleImage: View {
    var image: NSImage?
    var shadowRadius: CGFloat = 10

    var body: some View {
        if let img = self.image{
            Image(nsImage: img)
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.secondary, lineWidth: 3))
                .shadow(radius: shadowRadius)
        }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: NSImage(imageLiteralResourceName: "ethereum2"))
    }
}

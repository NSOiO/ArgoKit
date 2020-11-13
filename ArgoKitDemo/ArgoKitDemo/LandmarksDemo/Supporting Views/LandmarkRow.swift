/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single row to be displayed in a list of landmarks.
*/

import ArgoKit

struct LandmarkRow: View {
    
    var landmark: Landmark

    var body: View {
        Text("我是样式0").size(width: 100%, height: 44).alignContent(.center)
        HStack {
            landmark.image
                .resizable()
                .size(width: 50, height: 50)
            Spacer()
            Text(landmark.name)
        }
        HStack {
            Text(landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
    }
}

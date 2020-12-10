/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A single row to be displayed in a list of landmarks.
*/

import ArgoKit

class LandmarkRow: View {
    var node: ArgoKitNode? = ArgoKitNode(viewClass: UIView.self)
    var landmark: Landmark
    init(landmark: Landmark) {
        self.landmark = landmark
    }
    
    var body: View {
        Text("我是样式0").size(width: 100%, height: 44).alignContent(.center)
        HStack {
            self.landmark.image
                .resizable()
                .size(width: 50, height: 50).cornerRadius(10).clipsToBounds(true)
            Spacer()
            HStack{
                Text(self.landmark.name).alignSelf(.center)
            }.backgroundColor(.yellow)
            Spacer()
            Text(self.landmark.name)
           
        }
        HStack {
            Text(self.landmark.name)
            Text("👌").margin(top: 30, right: 40, bottom: 20, left: 10)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(self.landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(self.landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(self.landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
        HStack {
            Text(self.landmark.name)
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
            Text("👌")
        }
    }
}

//
//  LandmarkRow1.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/11/12.
//

import ArgoKit

class LandmarkRow1: View {
    
    var landmark: Landmark
    init(landmark: Landmark) {
        self.landmark = landmark
    }
    
    var body: View {
        Text("我是样式1").size(width: 100%, height: 44).alignContent(.center)
        HStack {
            self.landmark.image
                .resizable()
                .size(width: 50, height: 50)
            Spacer()
            Text(self.landmark.name)
        }
        self.landmark.image
            .resizable()
            .size(width: 50, height: 50)
        HStack {
            
            Text(self.landmark.name)
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
        }
        HStack {
            Text(self.landmark.name)
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
        }
        self.landmark.image
            .resizable()
            .size(width: 50, height: 50)
        HStack {
            Text(self.landmark.name)
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
        }
        self.landmark.image
            .resizable()
            .size(width: 50, height: 50)
        HStack {
            Text(self.landmark.name)
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
        }
        HStack {
            Text(self.landmark.name)
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
            Text("👍")
        }
    }
}

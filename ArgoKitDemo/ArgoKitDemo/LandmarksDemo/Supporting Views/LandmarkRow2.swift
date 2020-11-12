//
//  LandmarkRow2.swift
//  ArgoKitDemo
//
//  Created by MOMO on 2020/11/12.
//

import ArgoKit

struct LandmarkRow2: View {
    
    var landmark: Landmark

    var body: View {
        Text("我是样式2").size(width: 100%, height: 44).alignContent(.center)
        HStack {
            landmark.image
                .resizable()
                .size(width: 50, height: 50)
            Text(landmark.name)
        }
        HStack {
            landmark.image
                .resizable()
                .size(width: 50, height: 50)
            Text(landmark.name)
        }
        landmark.image
            .resizable()
            .size(width: 50, height: 50)
        HStack {
            
            Text(landmark.name)
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
        }
        HStack {
            Text(landmark.name)
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
        }
        landmark.image
            .resizable()
            .size(width: 50, height: 50)
        HStack {
            Text(landmark.name)
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
        }
        landmark.image
            .resizable()
            .size(width: 50, height: 50)
        HStack {
            Text(landmark.name)
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
            Text("🐯")
        }
    }
}

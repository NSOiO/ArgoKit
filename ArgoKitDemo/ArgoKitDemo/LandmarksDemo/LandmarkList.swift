/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import ArgoKit

class LandmarkList: View {
    var body: View {
        List(data:landmarkData) { landmark in
            switch landmark.reuseIdentifier {
            case "LandmarkRow1":
                LandmarkRow1(landmark: landmark)
            case "LandmarkRow2":
                LandmarkRow2(landmark: landmark)
            default:
                LandmarkRow(landmark: landmark)
            }
        }.size(width: 100%, height: 100%)
        .willDisplayCellForRowAtIndexPath { (indexPath) in

        }
        
//        Text("\(landmarkData)")
    }
}

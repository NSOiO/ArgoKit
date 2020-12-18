//
//  ArgoKitGridFlowLayout.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/17.
//

import Foundation
class GridFlowLayout: UICollectionViewFlowLayout {
    var columCount:Int = 1
    var width:CGFloat = 0
    var itemHeight:CGFloat = 0
    var frame:CGRect! = CGRect.zero{
        didSet{
            let width_ = frame.size.width
            let columSpace = minimumInteritemSpacing * CGFloat((columCount - 1))
            width = (width_ - columSpace - sectionInset.left - sectionInset.right) / CGFloat(columCount)
            width = floor(width)
            if itemHeight == 0 {
                itemSize = CGSize(width: width, height: itemHeight)
            }else{
                itemSize = CGSize(width: width, height: width)
            }
        }
    }
}

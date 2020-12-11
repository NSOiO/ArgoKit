//
//  ArgoKitImageTest.swift
//  ArgoKitDemo
//
//  Created by Bruce on 2020/12/11.
//

import ArgoKit

// view model.
class ArgoKitImageTestModel {

}

// view
struct ArgoKitImageTest: ArgoKit.View {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode()
    private var model: ArgoKitImageTestModel
    init(model: ArgoKitImageTestModel) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Image("icybay.jpg")
            .height(100)
            .shrink(1)
            .aspect(ratio: 1)
            .margin(edge: .top, value: 40)
            .circle()

        Image("icybay.jpg")
            .width(100)
            .aspect(ratio: 1)
            .alignSelf(.end)
            .margin(edge: .top, value: 10)
            .margin(edge: .right, value: 10)
            .backgroundColor(.yellow)
            .cornerRadius(10)
        
        Image("icybay.jpg")
            .width(150)
            .aspect(ratio: 1)
            .alignSelf(.center)
            .margin(edge: .top, value: 10)
            .backgroundColor(.yellow)
            .cornerRadius(10)
            .borderWidth(2)
            .borderColor(.red)
        
        Image("icybay.jpg")
            .width(100)
            .aspect(ratio: 1)
            .alignSelf(.stretch)
            .margin(edge: .top, value: 10)
            .backgroundColor(.clear)
            .shadow(color: .orange, offset: CGSize(width: 20, height: 20), radius: 13, opacity: 0.7, corners: .allCorners)
        
        // 加载远程图片
        Image(urlString:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJAAAACQCAMAAADQmBKKAAAABlBMVEX///8AAABVwtN+AAAETUlEQVR4nO2US7bcIAxEYf+bziB2S3WraPslGZBzYOAPSKorJBiTY4xxv69Rc2n1NviY6M81k75o9Xt6QyCP3R8lfofzaZNYTCNWpTLa9AF6BVTW5Q8vAbEZ4nSpdZjUnv8HUKrIsGEM/AFQmjtA/xIILSVRQVBDJDH9pT33B4LUtb6ulh6UaXMSo6KmfBj1AL0A8jZ4eswfPr7Govx2QMuB4nlFcGBwdPqvm3q1nscBovw0sxaxF9i7ZNkDPakYuh9l9d8HyO6JRQl68ZqaDaQpAWGDRrjeB+gVUJnZLzBeGyyOGtzRoJ8e2gnIdpqVySVrIXQGC7MPxC/TRnGAHoFUeSaBorp/oZF0kYrQZafrvR0QCmaWss3AFTdzkQUEX0c9QG+B6iHebw4oWkVVTErPKQYjbgGUCAwt7uv3LCSBTiwGyPoAvQH67gDRdAgk/PUV1XKakuO+QKWC26ELtAXbaTE1p9HXhCCCHKDvQKlpvAl6JAkGDGRRUVOGEv8TekOgkkAdZBMBJFLJvpclljjU6gC9AmrfenHlXxUKPVFzjCGtEmI43AGKQNDFETXmRoAsOvHACB3DDdF7aCeg/jf6vlpthlmBtJRjKoXmx7ajHKBHIHE0lcJt6+XXCQR3EaEreRZbApkhxbUENEAW+EIkEKCml98BegKyBklSFYSc5gdcp3OgeLr2BEpjpLE4TD0V4QvpuUjwP0AJCJ3TzUU+HR1A33NGP+vR9T3+pkC10/JIkA6W9PohBbPUCnK2GwcoA9nF6BZdmQt92n+n6ktSyx7dDyh5g5Nr3/x0dRhxhO1X1gF6ALKiSuyO1lZRcMwhpK8hYdmW/YDyRQI9KMslI7HNzp08/3DADtBXoJpfQGKhQgls6r6UUsJozJsCpYunl7H5IKyvaVL+g0DslQP0AghVBwvEZrdKuiP5Wa5Q0uibAWGvXT+VI11G9uWVKc8D9BdA0hZ2rPKNRtgvx0nQJLRlti/QYvfTjVEJyKPcFyrpK99I+neAEtCcFTGKmyjCzzBkVQiWWXysDtATUI4IqbsxeqTUi/ccHlNXp5kK9m5A/U8kxQx7raVVRMMUZ5QspHmAnoDyxYVIhSve4pkvOur6ifVc9wRaeJkyxeeE6TovWKUTeoB+BrRUQZDR4y0vzb6q7zHyJgwE3gXI9214EEYCHQpkpDyidirrdx6gF0DlgA6QBWMgWifBI6abhDcFkk1GsBJYXlmlEg36tCEF2AP0CGR8hslDsYidSD1MdY75rTZsM6BXVMRJaCLg18301bFmOkAdaHIY3Cyve7X3EmGvGPjCBtQaollv7QCUquV1E76khntLZmq6043u9+mGA/QKqAukSI7LOMG+UZUzUgki/wVQ31cRkFXYW+0jIgrlaAfoj4D6RScSDpYwnGuZnENuCtQDuGg+KH7dEKNMbNmzbqwH6AkIY9jwhXRW8kJTK8T+hQQO0CPQLzSJKD3xlkSVAAAAAElFTkSuQmCC", placeholder: "icybay.jpg")
            .width(100)
            .aspect(ratio: 1)
            .alignSelf(.center)
            .margin(edge: .top, value: 10)
            .backgroundColor(.clear)
            .shadow(color: .orange, offset: CGSize(width: 20, height: 20), radius: 13, opacity: 0.7, corners: .allCorners)
        
        
        
        
    }
}


#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
import ArgoKitPreview
import ArgoKitComponent
import SwiftUI

// mock data.
class ArgoKitImageTestModel_Previews:  ArgoKitImageTestModel {

}

@available(iOS 13.0.0, *)
struct ArgoKitImageTest_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
        return ArgoRender {
            ArgoKitImageTest(model: ArgoKitImageTestModel_Previews())
        }
    }
}
#endif

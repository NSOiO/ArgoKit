//
//  ArgoKitDatePicker.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/28.
//

import ArgoKit

// view model.
protocol ArgoKitDatePickerModelProtocol: ViewModelProtocol {
    var pickerData: DataSource<SectionDataList<String>> { get set }
    var rowStr1: String { get set }
    var rowStr2: String { get set }
    var rowStr3: String { get set }
}

// view
struct ArgoKitDatePicker: ArgoKit.ViewProtocol {
    typealias View = ArgoKit.View
    var node: ArgoKitNode? = ArgoKitNode(type: Self.self)
    private var model: ArgoKitDatePickerModelProtocol
    init(model: ArgoKitDatePickerModelProtocol) {
        self.model = model
    }
    
    var body: ArgoKit.View {
        Text("DatePicker")
        DatePicker{ date in
            print("\(date)")
        }
        .height(100)
        
        Text("PickerView Current Selected: " + model.rowStr1 + " " + model.rowStr2 + " " + model.rowStr3)
            .margin(edge: .top, value: 50)
        
        PickerView(model.pickerData) { item in
            Text(item)
                .backgroundColor(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
                .grow(1)
                .textAlign(.center)
        }
        .width(100%)
        .height(150)
        .widthForComponent({ (component) -> Float in
            switch component {
            case 1:
                return 50
            case 2:
                return 60
            default:
                return 40
            }
        })
        .rowHeightForComponent({ (component) -> Float in
            return 44
        })
        .didSelectRow({ (text, row, component) in
            switch component {
            case 0:
                model.rowStr1 = text
            case 1:
                model.rowStr2 = text
            case 2:
                model.rowStr3 = text
            default:
                break
            }
        })
        .backgroundColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
    }
}

extension ArgoKitDatePickerModelProtocol {
    func makeView() -> ArgoKit.View {
        ArgoKitDatePicker(model: self)
    }
}

#if canImport(SwiftUI) && canImport(ArgoKitPreview) && DEBUG
// mock data.
class ArgoKitDatePickerModelPreviews: ArgoKitDatePickerModelProtocol {
    var pickerData :DataSource<SectionDataList<String>>
    @Observable var rowStr1: String
    @Observable var rowStr2: String
    @Observable var rowStr3: String
    init() {
        pickerData = DataSource(SectionDataList<String>())
        pickerData.append(["1","2","3","4","5"])
        pickerData.append(["1","2","3","4","5"])
        pickerData.append(["1","2","3","4","5"])
        rowStr1 = pickerData[0][0]
        rowStr2 = pickerData[1][0]
        rowStr3 = pickerData[2][0]
    }
}

import ArgoKitPreview
import ArgoKitComponent
import SwiftUI
@available(iOS 13.0.0, *)
private func argoKitRender(@ArgoKitViewBuilder builder:@escaping ()-> ArgoKit.View) -> ArgoRender {
    ArgoKitInstance.registerImageLoader(imageLoader: ArgoKitComponent.ImageLoader())
    ArgoKitInstance.registerPreviewService(previewService: ArgoKitPreview.listPreviewService())
    ArgoKit.Dep.registerDep( _argokit__preview_dep_ )
    return ArgoRender(builder: builder)
}

@available(iOS 13.0.0, *)
struct ArgoKitDatePickerPreviews: PreviewProvider {
    static var previews: some SwiftUI.View {
        // 数组中可以添加其他设备进行多设备预览
        SwiftUI.ForEach([.iPhone11]) { item in
            argoKitRender {
                ArgoKitDatePickerModelPreviews().makeView()
            }
            .previewDevice(item.device)
            .previewDisplayName(item.name)
        }
    }
}
#endif


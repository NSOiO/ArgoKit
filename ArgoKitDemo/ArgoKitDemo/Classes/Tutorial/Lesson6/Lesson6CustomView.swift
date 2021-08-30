//
//  Lesson6CustomView.swift
//  ArgoKitTutorial
//
//  Created by ChenJian on 2021/8/20.
//

import UIKit

struct Lesson6CustomViewDataModel {
    var imgName: String
    var textStr: String
}

class Lesson6CustomView: UIView {
    
    var imageView = UIImageView()
    var textLabel = UILabel()
    
    init(frame: CGRect, model: Lesson6CustomViewDataModel) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        layer.cornerRadius = 10
        imageView.image = UIImage(named: model.imgName)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        textLabel.text = model.textStr
        textLabel.textAlignment = .center
        
        updateFrame()
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateFrame() {
        imageView.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 40)
        textLabel.frame = CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20)
    }
}

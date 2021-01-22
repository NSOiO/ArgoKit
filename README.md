# ArgoKit

ArgoKit is a SwiftUI replacement Framework based on UIKit, that is compatible with iOS 11+. 

## Introduction

- **Declarative** ArgoKit uses almost the same `DSL` as SwiftUI(e.g., `Text` `Button` `List` ).You simply describe the UI elements and Animation, and the framework takes care of the rest.

- **React** The created view automatically listens directly to streams and updates the DOM accordingly.

-  **Flexbox Layout** ArgoKit uses [Yoga](https://facebook.github.io/yoga/) as layout engine.


- **Preview and templating** ArgoKit uses the same preview approach as SwiftUI, and you can be easily developed through the template files.

## API Documentation

[API Documentation](https://momotech.github.io/argokit/)

## Usage

### Installation

```
pod 'ArgoKit'
pod 'ArgoKitPreview', :configuration => 'Debug'
```

#### Declarative

```swift
        HStack {
            Text("11")
                .textColor(.red)
            Text("22")
                .textColor(.blue)
            Text("33")
                .backgroundColor(.orange)
        }
        .justifyContent(.between)
        .padding(edge: .horizontal, value: 10)
        .backgroundColor(.lightGray)
```
![dsl](Resources/dsl.png)

#### Animation

```swift
        Text("Hello, ArgoKit!")
            .addAnimation {
                Animation(type: .rotation)
                    .duration(3.0)
                    .to(360)
                    .repeatForever(true)
                    .repeatCallback { (animation, count) in
                        print("[Animation] repeat count:\(count)")
                    }
                    .startCallback { animation in
                        print("[Animation] start")
                    }
                    .resumeCallback { animation in
                        print("[Animation] resume")
                    }
                    .pauseCallback { animation in
                        print("[Animation] pause")
                    }
                    .finishCallback { (animation, finished) in
                        print("[Animation] finish \(finished)")
                    }
        }
```


####  React 

- Auto Data Bind

```swift
class FeedCellModel {
   @Property var title: String = "is title"
   func getTitle() {
      self.title + " \(self.age)"
   }

   func titleAction() {
	model.title = "change title"
	model.age = 20
   }
}

Text(model.getTitle())
   .onTapGesture(model.titleAction)
```

#### Preview
![preview](Resources/preview.png)

#### Tempalte 
![template](Resources/template.png)

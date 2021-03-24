# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
  spec.name = 'ArgoKit'
  spec.version = '1.0.14'
  spec.license =  { :type => 'MIT', :file => "LICENSE" }
  spec.homepage = 'https://git.wemomo.com/module/argokit'
  spec.documentation_url = 'https://momotech.github.io/argokit/'

  spec.summary = 'A Declarative and Reactive Framework.'
  spec.description = <<-DESC
  ArgoKit is a declarative and reactive Framework and based on UIKit, inspired by SwiftUI, compatible with iOS 11+.
  
  - **Declarative** ArgoKit uses almost the same `DSL` as SwiftUI(e.g., `Text` `Button` `List` ).You simply describe the UI elements and Animation, and the framework takes care of the rest.
  - **React** The created view automatically listens directly to streams and updates the DOM accordingly.
  - **Flexbox Layout** ArgoKit uses [Yoga](https://facebook.github.io/yoga/) as layout engine.
  - **Preview and templating** ArgoKit uses the same preview approach as SwiftUI, and you can be easily developed through the template files.
  DESC

  spec.authors = 'MoMo'
  spec.source = {
    :git => 'https://git.wemomo.com/module/argokit.git',
    :tag => spec.name + '/' + spec.version.to_s,
  }

  spec.platform = :ios
  spec.ios.deployment_target = '11.0'
  spec.ios.frameworks = 'UIKit'
  spec.dependency 'Yoga'
  spec.module_name = 'ArgoKit'
  spec.header_dir = '.'

#  spec.source_files = 'Source/ArgoKit.h'
#  spec.module_map = 'Source/module.modulemap'
  
  spec.libraries = 'z','c++'
  
  spec.subspec 'AnimationKit' do |ani|
    ani.name = 'AnimationKit'
    ani.dependency 'ArgoAnimation'
    ani.source_files = 'Source/AnimationKit/**/*.{h,m,mm,c,cpp,swift}'
#    ani.public_header_files = 'Source/AnimationKit/*.h', 'Source/AnimationKit/MLAnimator/*.h', 'Source/AnimationKit/MLAnimator/Animations/*.h'
#    ani.compiler_flags = '-x objective-c++'
  end
  
  spec.subspec "Bind" do |s|
    s.source_files = 'Source/Bind/**/*.{swift}'
  end
  
  spec.subspec "Core" do |ss|
    ss.source_files = 'Source/Core/**/*.{h,m,mm}','Source/Core/**/*.{swift}'
    ss.dependency 'ArgoKit/AnimationKit'
    ss.dependency 'ArgoKit/Bind'
#    ss.private_header_files = 'ArgoKit/Source/*.h'
    ss.public_header_files = 'ArgoKit/Source/*.h'
  end
end

# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
    spec.name = 'ArgoKitComponent'
    spec.version = '1.0.1'
    spec.license =  { :type => 'MIT', :file => "LICENSE" }
    spec.homepage = 'https://git.wemomo.com/module/argokit'
  
    spec.summary = 'ArgoKitComponent'
  
    spec.authors = 'MoMo'
    spec.source = {
      :git => 'https://git.wemomo.com/module/argokit.git',
      :tag => spec.name + '/' + spec.version.to_s,
    }
    spec.platform = :ios
    spec.ios.deployment_target = '10.0'
    spec.ios.frameworks = 'UIKit', 'SwiftUI'
    spec.module_name = spec.name

    spec.dependency 'ArgoKit'
    # spec.source_files = "Source/Component/**/*.{h,m,mm,swift}"

    spec.subspec "ImageLoader" do |ss|
      ss.source_files = 'Source/Component/ImageLoader/**/*.{h,m,mm,swift}'
      # ss.private_header_files = 'ArgoKit/Source/*.h'
      ss.dependency 'SDWebImage'
    end

  end

  

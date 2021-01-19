# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
    spec.name = 'ArgoKitComponent'
    spec.version = '1.0.5'
    spec.license =  { :type => 'MIT', :file => "LICENSE" }
    spec.homepage = 'https://git.wemomo.com/module/argokit'
  
    spec.summary = 'ArgoKitComponent'
  
    spec.authors = 'MoMo'
    spec.source = {
      :git => 'https://git.wemomo.com/module/argokit.git',
      :tag => spec.name + '/' + spec.version.to_s,
    }
    spec.platform = :ios
    spec.ios.deployment_target = '11.0'
    spec.ios.frameworks = 'UIKit'
    spec.module_name = spec.name

    spec.dependency 'ArgoKit'

    #spec.default_subspec = 'SDImageLoader', 'YYText', 'Refresh'
    spec.default_subspec = 'Core'
    
    spec.subspec "Core" do |ss|
      ss.source_files = 'Source/Component/Core/**/*.{h,m,mm,swift}'
#      ss.dependency 'ArgoKitComponent/SDImageLoader'
    end
    
    spec.subspec "SDImageLoader" do |ss|
      ss.source_files = 'Source/Component/SDImageLoader/**/*.{h,m,mm,swift}'
      ss.dependency 'SDWebImage'
      ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'SDIMAGELOADER=1' }
      ss.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-D SDIMAGELOADER' }
    end
    
    spec.subspec "KFImageLoader" do |ss|
      ss.source_files = 'Source/Component/KFImageLoader/**/*.{h,m,mm,swift}'
      ss.dependency 'Kingfisher'
      ss.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'KFIMAGELOADER=1' }
      ss.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-D KFIMAGELOADER' }
    end

    spec.subspec "YYText" do |ss|
      ss.source_files = 'Source/Component/YYText/**/*.{h,m,mm,swift}'
      ss.dependency 'YYText'
    end
    
    spec.subspec "Refresh" do |ss|
      ss.source_files = 'Source/Component/Refresh/**/*.{h,m,mm,swift}'
      ss.dependency 'MJRefresh'
    end
    
  end

  

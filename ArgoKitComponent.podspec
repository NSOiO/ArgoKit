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

    spec.default_subspec = 'SDImageLoader', 'YYText', 'Refresh'
    
    spec.subspec "SDImageLoader" do |ss|
      ss.source_files = 'Source/Component/SDImageLoader/**/*.{h,m,mm,swift}'
      ss.dependency 'SDWebImage'
    end
    
    spec.subspec "KFImageLoader" do |ss|
      ss.source_files = 'Source/Component/KFImageLoader/**/*.{h,m,mm,swift}'
      ss.dependency 'Kingfisher'
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

  

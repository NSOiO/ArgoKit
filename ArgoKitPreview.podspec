# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
    spec.name = 'ArgoKitPreview'
    spec.version = '1.0.1'
    spec.license =  { :type => 'MIT', :file => "LICENSE" }
    spec.homepage = 'https://git.wemomo.com/module/argokit'
    # spec.documentation_url = 'argokit'
  
    spec.summary = 'ArgoKitPreview'
    # spec.description = 'argokit'
  
    spec.authors = 'MoMo'
    spec.source = {
      :git => 'https://git.wemomo.com/module/argokit.git',
      :tag => spec.version.to_s,
    }
  
    spec.platform = :ios
    spec.ios.deployment_target = '10.0'
    spec.ios.frameworks = 'UIKit', 'SwiftUI'
#    spec.ios.frameworks = 'SwiftUI'

  #  spec.default_subspec = "Core"
    # spec.dependency 'Yoga', '~> 1.14'
    spec.dependency 'ArgoKit'
    spec.module_name = 'ArgoKitPreview'
    spec.source_files = "Source/Preview/**/*.{h,m,mm,swift}"
    # spec.libraries = 'z','c++'

    # spec.subspec "Core" do |ss|
    #   ss.source_files = 'Source/Core/**/*.{h,m,mm}','Source/Core/**/*.{swift}'
    #   ss.private_header_files = 'ArgoKit/Source/*.h'
    # end

  
  end
  
  # See https://github.com/facebook/yoga/pull/366
  #podspec.attributes_hash["readme"] = "argokit/README.md"

  

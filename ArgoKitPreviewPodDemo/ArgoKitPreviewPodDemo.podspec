# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
    spec.name = 'ArgoKitPreviewPodDemo'
    spec.version = '1.0.0'
    spec.license =  { :type => 'MIT', :file => "LICENSE" }
    spec.homepage = 'https://git.wemomo.com/module/argokit'
    # spec.documentation_url = 'argokit'
  
    spec.summary = 'ArgoKitPreviewPodDemo'
    # spec.description = 'argokit'
  
    spec.authors = 'MoMo'
    spec.source = {
      :git => 'https://git.wemomo.com/module/argokit.git',
      :tag => spec.name + '/' + spec.version.to_s,
    }
  
    spec.platform = :ios
    spec.ios.deployment_target = '10.0'
    spec.ios.frameworks = 'UIKit', 'SwiftUI'

    spec.dependency 'ArgoKit'
    spec.dependency 'ArgoKitPreview'

    # spec.dependency 'ArgoKitComponent'
    
    spec.module_name = 'ArgoKitPreviewPodDemo'
    # spec.source_files = "Files/**/*.{h,m,mm,swift}"
    
    spec.subspec "Core" do |ss|
      ss.source_files = 'Core/**/*.{h,m,mm,swift}'
      # ss.private_header_files = 'ArgoKit/Source/*.h'
      # ss.dependency 'SDWebImage'
    end

  end
  
  # See https://github.com/facebook/yoga/pull/366
  #podspec.attributes_hash["readme"] = "argokit/README.md"

  

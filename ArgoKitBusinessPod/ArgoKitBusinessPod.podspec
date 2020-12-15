# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
    spec.name = 'ArgoKitBusinessPod'
    spec.version = '1.0.0'
    spec.license =  { :type => 'MIT', :file => "LICENSE" }
    spec.homepage = 'https://git.wemomo.com/module/argokit'
    # spec.documentation_url = 'argokit'
  
    spec.summary = 'ArgoKitBusinessPod'
    # spec.description = 'argokit'
  
    spec.authors = 'MoMo'
    spec.source = {
      :git => 'https://git.wemomo.com/module/argokit.git',
      :tag => spec.name + '/' + spec.version.to_s,
    }
  
    spec.platform = :ios
    spec.ios.deployment_target = '10.0'
    spec.ios.frameworks = 'UIKit'

    spec.dependency 'ArgoKit'    
    spec.module_name = 'ArgoKitBusinessPod'
    spec.source_files = "Core/**/*.{h,m,mm,swift}"
  end
  
  # See https://github.com/facebook/yoga/pull/366
  #podspec.attributes_hash["readme"] = "argokit/README.md"

  

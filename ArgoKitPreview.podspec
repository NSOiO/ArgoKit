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

    spec.dependency 'ArgoKit'
    spec.dependency 'ArgoKitComponent'
    
    spec.module_name = 'ArgoKitPreview'
    spec.source_files = "Source/Preview/**/*.{h,m,mm,swift}"
#    spec.resources = ['Source/Script/**/*']
    spec.resources = ['Source/Script/*']
    spec.prepare_command = <<-CMD
                pwd
                chmod +x  ./Source//Script/config.sh
                ./Source//Script/config.sh
    CMD
  end
  
  # See https://github.com/facebook/yoga/pull/366
  #podspec.attributes_hash["readme"] = "argokit/README.md"

  

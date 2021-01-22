# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
    spec.name = 'ArgoKitPreview'
    spec.version = '1.0.10'
    spec.license =  { :type => 'MIT', :file => "LICENSE" }
    spec.homepage = 'https://git.wemomo.com/module/argokit'
    # spec.documentation_url = 'argokit'
  
    spec.summary = 'ArgoKitPreview'
    # spec.description = 'argokit'
  
    spec.authors = 'MoMo'
    spec.source = {
      :git => 'https://git.wemomo.com/module/argokit.git',
      :tag => spec.name + '/' + spec.version.to_s,
    }
  
    spec.platform = :ios
    spec.ios.deployment_target = '11.0'
    spec.ios.frameworks = 'UIKit'
    spec.ios.weak_frameworks = 'SwiftUI'

    spec.dependency 'ArgoKit'
    spec.dependency 'ArgoKitComponent'
    
    spec.module_name = 'ArgoKitPreview'
    spec.source_files = "Source/Preview/src/**/*.{h,m,mm,swift}"
#    spec.resources = ['Source/Script/**/*']
    spec.resources = ['Source/Script/*', 'Source/Preview/*.swift']
    spec.prepare_command = <<-CMD
        path=./Source//Script/config.sh
        if [ -f "$path" ]; then
          sh $path
        else
          echo "$path not exist"
        fi
    CMD
  end
        

  

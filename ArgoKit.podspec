# Copyright (c) MoMo, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
  spec.name = 'ArgoKit'
  spec.version = '1.0.1'
  spec.license =  { :type => 'MIT', :file => "LICENSE" }
  spec.homepage = 'https://git.wemomo.com/module/argokit'
  spec.documentation_url = 'argokit'

  spec.summary = 'argokit'
  spec.description = 'argokit'

  spec.authors = 'MoMo'
  spec.source = {
    :git => 'argokit',
    :tag => spec.version.to_s,
  }

  spec.platform = :ios
  spec.ios.deployment_target = '10.0'
  spec.ios.frameworks = 'UIKit'
  spec.dependency 'Yoga'
  spec.module_name = 'ArgoKit'
  
  spec.libraries = 'z','c++'

  spec.subspec "Core" do |ss|
    ss.source_files = 'Source/Core/**/*.{h,m,mm}','Source/Core/**/*.{swift}'
#    ss.private_header_files = 'ArgoKit/Source/*.h'
    ss.public_header_files = 'ArgoKit/Source/*.h'
  end
  
  spec.subspec "Bind" do |s|
    s.source_files = 'Source/Bind/**/*.{swift}'
  end
  
  spec.subspec 'AnimationKit' do |ani|
    ani.name = 'AnimationKit'
    ani.dependency 'ArgoAnimation'
    ani.source_files = 'Source/AnimationKit/**/*.{h,m,mm,c,cpp,swift}'
#    ani.public_header_files = 'Source/AnimationKit/*.h', 'Source/AnimationKit/MLAnimator/*.h', 'Source/AnimationKit/MLAnimator/Animations/*.h'
#    ani.compiler_flags = '-x objective-c++'
  end

end

# See https://github.com/facebook/yoga/pull/366
#podspec.attributes_hash["readme"] = "argokit/README.md"
podspec

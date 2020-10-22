# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

podspec = Pod::Spec.new do |spec|
  spec.name = 'ArgoKit'
  spec.version = '1.0.0'
  spec.license =  { :type => 'MIT', :file => "LICENSE" }
  spec.homepage = 'https://facebook.github.io/yoga/'
  spec.documentation_url = 'https://facebook.github.io/yoga/docs/'

  spec.summary = 'Yoga is a cross-platform layout engine which implements Flexbox.'
  spec.description = 'Yoga is a cross-platform layout engine enabling maximum collaboration within your team by implementing an API many designers are familiar with, and opening it up to developers across different platforms.'

  spec.authors = 'Facebook'
  spec.source = {
    :git => 'https://github.com/facebook/yoga.git',
    :tag => spec.version.to_s,
  }

  spec.platform = :ios
  spec.ios.deployment_target = '9.0'
  spec.ios.frameworks = 'UIKit'
  spec.default_subspec = "Core"
  spec.dependency 'Yoga', '~> 1.14'
  spec.module_name = 'ArgoKit'

  spec.subspec "Core" do |ss|
    ss.source_files = 'Source/*.{h,m,mm}','Source/*.{swift}'
    ss.public_header_files = 'Source/*.h'
#    ss.private_header_files = 'ArgoKit/Source/*.h'
  end

end

# See https://github.com/facebook/yoga/pull/366
podspec.attributes_hash["readme"] = "YogaKit/README.md"
podspec

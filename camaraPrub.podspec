Pod::Spec.new do |s|
s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "camaraPrub"
s.summary = "Pod para tomar fotos de documentos de manera automatica"
s.requires_arc = true
s.swift_version = '5.0'
s.version = "0.0.1"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "fractanet" => "irisgalgal@outlook.com" }
s.homepage = "https://github.com/irisgal27/VersionLast"
s.source = { :git => "https://github.com/irisgal27/VersionLast.git", :tag => "#{s.version}"}
s.framework = "UIKit","Vision"
s.source_files = "camaraPrub/**/*.{swift}"
s.resources = ["camaraPrub/**/*.{png,jpeg,jpg,lproj,storyboard,xib,xcassets}","camaraPrub/Resources/DocumentCamera.storyboard"]
s.resource_bundles = {
    'camaraPrub' => ['camaraPrub/Assets/**/*.xcassets', 'camaraPrub/**/*.{lproj,storyboard,boundle}']
  }
end


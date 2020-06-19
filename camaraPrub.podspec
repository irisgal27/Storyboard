Pod::Spec.new do |s|
s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "camaraPrub"
s.summary = "Pod para tomar fotos de documentos de manera automática"
s.requires_arc = true
s.swift_version = '5.0'
s.version = "0.4.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "GrupoPanxea" => "irisgalgal@outlook.com" }
s.homepage = "https://github.com/GrupoPanxea/ios-images-lib-pod"
s.source = { :git => "https://github.com/GrupoPanxea/ios-images-lib-pod.git", :tag => "#{s.version}"}
s.framework = "UIKit","Vision"
s.source_files = "camaraPrub/**/*.{swift}"
s.resources = ["camaraPrub/**/*.{png,jpeg,jpg,lproj,storyboard,xib,xcassets}","camaraPrub/Resources/DocumentCamera.storyboard"]
s.resource_bundles = {
    'camaraPrub' => ['camaraPrub/Assets/**/*.xcassets', 'camaraPrub/**/*.{lproj,storyboard,boundle}']
  }
end


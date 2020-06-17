Pod::Spec.new do |s|
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "camaraPrub"
s.summary = "A short description of camaraPrub."
s.requires_arc = true
s.version = "0.0.1"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "fractanet" => "irisgalgal@outlook.com" }
s.homepage = "https://github.com/irisgal27/Storyboard"
s.source = { :git => "https://github.com/irisgal27/Storyboard.git", :tag => "#{s.version}"}
s.framework = "UIKit"
s.source_files = "camaraPrub/**/*.{swift}"
s.resources = "camaraPrub/**/*.{png,jpeg,jpg,storyboard,xib}"
end


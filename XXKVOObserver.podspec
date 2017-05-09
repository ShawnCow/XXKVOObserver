
Pod::Spec.new do |s|
s.name             = "XXKVOObserver"
s.version          = "0.0.1"
s.summary          = "kvo dahuang"
s.description      = <<-DESC
It is a marquee view used on iOS, which implement by Objective-C.
DESC
s.homepage         = "https://github.com/ShawnCow/XXKVOObserver"
# s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author             = { "大黄" => "rockhxy@gmail.com" }
s.source       = { :git => "https://github.com/ShawnCow/XXKVOObserver.git", :tag => "0.0.1" }
# s.social_media_url = 'https://twitter.com/NAME'

s.platform     = :ios, '4.3'
# s.ios.deployment_target = '5.0'
# s.osx.deployment_target = '10.7'
s.requires_arc = true

s.source_files = 'XXKVOObserver/*'
# s.resources = 'Assets'

# s.ios.exclude_files = 'Classes/osx'
# s.osx.exclude_files = 'Classes/ios'
# s.public_header_files = 'Classes/**/*.h'
s.frameworks = 'Foundation','UIKit'

end

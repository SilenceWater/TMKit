

Pod::Spec.new do |s|
  s.name             = 'TMKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TMKit.'



  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/SilenceWater/TMKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '王士昌' => 'wwwarehouse@163.com' }
  s.source           = { :git => 'https://github.com/SilenceWater/TMKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TMKit/Classes/**/*.{h,m}'
  
  s.resource_bundles = {
     'TMKit' => ['TMKit/Assets/*.xcassets']
    }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Masonry'
end

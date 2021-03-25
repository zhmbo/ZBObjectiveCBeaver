Pod::Spec.new do |s|
  s.name             = 'ZBObjectiveCBeaver'
  s.version          = '0.2.0'
  s.summary          = 'ios log.'
  s.description      = 'https://github.com/itzhangbao/ZBObjectiveCBeaver/blob/master/README.md'
  s.homepage         = 'https://github.com/itzhangbao/ZBObjectiveCBeaver'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'itzhangbao' => 'itzhangbao@163.com' }
  s.source           = { :git => 'https://github.com/itzhangbao/ZBObjectiveCBeaver.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZBObjectiveCBeaver/*.{h,m}'
  s.default_subspecs = ''
  
  s.subspec 'AVOSCloud' do |ss|
    ss.source_files = 'ZBObjectiveCBeaver/AVOSCloud/**/*'
  end

  s.frameworks  = "UIKit", "AVFoundation"
end

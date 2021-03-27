Pod::Spec.new do |s|
  s.name             = 'ZBObjectiveCBeaver'
  s.version          = '0.7.0'
  s.summary          = 'ios log.'
  s.description      = 'https://github.com/itzhangbao/ZBObjectiveCBeaver/blob/master/README.md'
  s.homepage         = 'https://github.com/itzhangbao/ZBObjectiveCBeaver'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'itzhangbao' => 'itzhangbao@163.com' }
  s.source           = { :git => 'https://github.com/itzhangbao/ZBObjectiveCBeaver.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZBObjectiveCBeaver/ZBObjectiveCBeaver.h'
  s.default_subspec = 'Core', 'Utils', 'CustomAPI'
    
  s.subspec 'Core' do |ss|
    ss.source_files = 'ZBObjectiveCBeaver/Core/*'
    ss.dependency 'ZBObjectiveCBeaver/Utils'
  end
    
  s.subspec 'Utils' do |ss|
    ss.source_files = 'ZBObjectiveCBeaver/Utils/*'
  end
    
  s.subspec 'CustomAPI' do |ss|
    ss.source_files = 'ZBObjectiveCBeaver/CustomAPI/*'
    ss.dependency 'ZBObjectiveCBeaver/Utils'
    ss.dependency 'ZBObjectiveCBeaver/Core'
  end
  
  s.subspec 'AVOSCloud' do |ss|
    ss.source_files = 'ZBObjectiveCBeaver/AVOSCloud/*', 'ZBObjectiveCBeaver/ZBObjectiveCBeaver.h'
    ss.dependency 'ZBObjectiveCBeaver/Utils'
    ss.dependency 'ZBObjectiveCBeaver/Core'
    ss.dependency 'AVOSCloud'
  end

  s.frameworks  = "UIKit", "AVFoundation"
end

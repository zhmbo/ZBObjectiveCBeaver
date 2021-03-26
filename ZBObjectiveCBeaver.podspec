Pod::Spec.new do |s|
  s.name             = 'ZBObjectiveCBeaver'
  s.version          = '0.4.0'
  s.summary          = 'ios log.'
  s.description      = 'https://github.com/itzhangbao/ZBObjectiveCBeaver/blob/master/README.md'
  s.homepage         = 'https://github.com/itzhangbao/ZBObjectiveCBeaver'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'itzhangbao' => 'itzhangbao@163.com' }
  s.source           = { :git => 'https://github.com/itzhangbao/ZBObjectiveCBeaver.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZBObjectiveCBeaver/ZBObjectiveCBeaver.h', 'ZBObjectiveCBeaver/ZBLogMacros.h'
  s.default_subspec = 'Core'
    
  s.subspec 'Core' do |ss|
    ss.source_files = 'ZBObjectiveCBeaver/Core/*'
  end
  
  s.subspec 'AVOSCloud' do |ss|
    ss.source_files = 'ZBObjectiveCBeaver/AVOSCloud/**/*'
    ss.dependency 'ZBObjectiveCBeaver/Core'
  end

  s.frameworks  = "UIKit", "AVFoundation"
end

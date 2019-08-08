Pod::Spec.new do |s|
  s.name         = "KeyPathExtension"
  s.version      = "1.0.6"
  s.summary      = 'An extension of KeyPath in KVC for objc runtime.Describe complex logic with less code in KeyPath.Reduce programmer doing work.'
  s.homepage     = 'https://github.com/Meterwhite/KeyPathExtension'
  s.license      = 'MIT'
  s.author       = { "Meterwhite" => "meterwhite@outlook.com" }
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/Meterwhite/KeyPathExtension.git", :tag => s.version}
  s.source_files  = 'KeyPathExtension/**/*.{h,m}'
end
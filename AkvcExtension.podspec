Pod::Spec.new do |s|
  s.name         = "AkvcExtension"
  s.version      = "1.0.4"
  s.summary      = 'An extension of KeyPath for KVC.Describe complex logic with less code in KeyPath.Reduce programmer doing work.'
  s.homepage     = 'https://github.com/qddnovo/AkvcExtension'
  s.license      = 'MIT'
  s.author       = { "Novo" => "quxingyi@outlook.com" }
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/qddnovo/AkvcExtension.git", :tag => s.version}
  s.source_files  = 'AkvcExtension/**/*.{h,m}'
end
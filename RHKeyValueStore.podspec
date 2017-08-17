
Pod::Spec.new do |s|

  s.name         = "RHKeyValueStore"
  s.version      = "0.1.1"
  s.summary      = "Key-Value storage tool, based on WCDB (WeChat DataBase)."
  s.homepage     = "https://github.com/Rannie/RHKeyValueStore"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Hanran Liu" => "18622218653@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Rannie/RHKeyValueStore.git", :tag => "v0.1.1" }
  s.source_files = "RHKeyValueStore", "RHKeyValueStore/*.{h,m}"
  s.public_header_files = "RHKeyValueStore/*.h"
  s.framework    = "Foundation"
  s.requires_arc = true
  s.dependency "WCDB", "~> 1.0.3"

end

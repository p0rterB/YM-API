Pod::Spec.new do |spec|
  spec.name         = "YM-API"
  spec.version      = "0.6.3"
  spec.summary      = "Unofficial Yandex Music API"
  spec.homepage     = "https://github.com/p0rterB/YM-API"
  spec.license      = { :type => "GNU LGPL v3.0", :file => "LICENSE" }
  spec.author       = { "Chris" => "chris.nik.70@protonmail.com" }
  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.14"
  spec.swift_version = "5.0"
  spec.source        = { :git => "https://github.com/p0rterB/YM-API.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes/*.swift", "Classes/**/*.swift"
  spec.exclude_files = "Classes/Exclude", "Classes/Exclude/*.*"
  spec.framework     = "Foundation"
end

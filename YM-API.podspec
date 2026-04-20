Pod::Spec.new do |spec|
  spec.name                      = "YM-API"
  spec.version                   = "0.7.1"
  spec.summary                   = "Unofficial Yandex Music API"
  spec.homepage                  = "https://github.com/p0rterB/YM-API"
  spec.license                   = { :type => "GNU LGPL v3.0", :file => "LICENSE" }
  spec.author                    = { "Chris" => "chris.nik.70@protonmail.com" }
  spec.ios.deployment_target     = "10.0"
  spec.osx.deployment_target     = "10.12"
  spec.tvos.deployment_target    = "10.0"
  spec.watchos.deployment_target = "3.0"
  spec.swift_versions            = ["5.3", "5.9", "5.10"]
  spec.swift_version             = "5.3"
  spec.source                    = { :git => "https://github.com/p0rterB/YM-API.git", :tag => "#{spec.version}" }
  spec.source_files              = "Sources/YMAPI/*.swift", "Sources/YMAPI/**/*.swift"
  spec.framework                 = "Foundation"
  spec.resource_bundles          = {'YM-API' => ['Sources/YMAPI/PrivacyInfo.xcprivacy']}
end

Pod::Spec.new do |s|
    s.name          = 'KIRIEngineSDK'
    s.version       = '1.1.4'
    s.summary       = "kiri's sdk collection"
    s.homepage      = 'https://github.com/Kiri-Innovation/KIRI-ENGINE-SDK-API'
    s.license       = { 
        type: 'KIRI Platform License',
        text: <<-LICENSE
        Copyright (c) KIRI Platforms
        LICENSE
     }
    s.author        = 'KIRI'
    s.source        = {
        http: "https://repository.kiri-engine.com/repository/iOS-SDK/#{s.version}/KIRIEngineSDK.xcframework.zip"
    }

    s.swift_version = '5.0'
    s.ios.deployment_target = '13.0'
  
    s.vendored_frameworks = 'KIRIEngineSDK.xcframework'
  end

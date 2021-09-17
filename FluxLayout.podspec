Pod::Spec.new do |s|
    s.name             = "FluxLayout"
    s.version          = "0.1"
    s.summary          = "Open source AutoLayout DSL inspired by FlexBox and FlexLayout. Full compatable with AutoLayout"

    s.homepage         = "https://github.com/Tanelxen/FluxLayout"
    s.license          = "MIT"
    s.author           = "Fedor Artemenkov"
    s.social_media_url = ""
    s.source           = { :git => "https://github.com/Tanelxen/FluxLayout.git", :tag => s.version.to_s }

    s.ios.deployment_target = "8.0"
    s.tvos.deployment_target = "9.0"

    s.source_files  = "Sources/**/*"
end

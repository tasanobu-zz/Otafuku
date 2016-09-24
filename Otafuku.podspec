Pod::Spec.new do |s|
  s.name = 'Otafuku'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'Otafuku provides utility classes to use WKWebView'
  s.homepage = 'https://github.com/tasanobu/Otafuku'
  s.social_media_url = 'http://twitter.com/tasanobu'
  s.authors = { 'Kazunobu Tasaka' => 'tasanobu@gmail.com' }
  s.source = { :git => 'https://github.com/tasanobu/Otafuku.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*.swift'
  # Note: Need to specify Kamagari's 'swift3.0' branch in Podfile, until Kamagari supports Swift 3, 
  s.dependency 'Kamagari', '~> 1.0.1'
  s.requires_arc = true
end

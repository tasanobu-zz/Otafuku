Pod::Spec.new do |s|
  s.name = 'Otafuku'
  s.version = '0.8.0' 
  s.license = 'MIT'
  s.summary = 'Otafuku provides utility classes to use WKWebView'
  s.homepage = 'https://github.com/tasanobu/Otafuku'
  s.social_media_url = 'http://twitter.com/tasanobu'
  s.authors = { 'Kazunobu Tasaka' => 'tasanobu@gmail.com' }
  s.source = { :git => 'https://github.com/tasanobu/Otafuku.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*.swift'
  s.dependency = 'Kamagari'
  s.requires_arc = true
end

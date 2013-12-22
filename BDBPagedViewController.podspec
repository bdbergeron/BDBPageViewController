Pod::Spec.new do |s|
  s.name      = 'BDBPagedViewController'
  s.version   = '0.1.0'
  s.license   = 'MIT'
  s.summary   = 'View controller class for displaying paged content.'
  s.homepage  = 'https://github.com/bdbergeron/BDBPagedViewController'
  s.authors   = { 'Bradley David Bergeron' => 'brad@bradbergeron.com' }
  s.source    = { :git => 'https://github.com/bdbergeron/BDBPagedViewController.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.platform = :ios, '6.0'

  s.source_files = 'BDBPagedViewController/*.{h,m}'
end

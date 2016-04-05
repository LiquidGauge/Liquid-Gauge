Pod::Spec.new do |s|
  s.name         = "LiquidGauge"
  s.version      = "0.0.1"
  s.summary      = "Liquid Gauge"
  s.description  = <<-DESC
  This library provides an easy to use and fully customizable class to simulate liquid and represent a percentage in a view easyli.

  The view content is based on a percentage and is usable as a gauge.

  The liquid view has fully customizable appearance and behavior. (See configuration section)

  The view should be used with a mask in front of it to simulate the container.
                   DESC

  s.homepage     = "https://github.com/LiquidGauge/Liquid-Gauge"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Liquid Gauge" => "todo@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LiquidGauge/Liquid-Gauge.git", :tag => "0.0.1" }
  s.source_files  = "LiquidGauge/**/*.swift"
end

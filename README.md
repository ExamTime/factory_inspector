# FactoryInspector

This very simple gem reports on how FactoryGirl factories 
are being used during your test runs. This is useful in
understanding where the time is going during your test
runs.

This is a developer's tool; the Gem makes no effort to
sanitize inputs or help you avoid making mistakes.

## Installation

Add this line to your application's Gemfile:

    gem 'factory_inspector'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install factory_inspector

## Usage

Let's take a hypothetical `spec/spec_helper.rb` on a RSpec based
project.

```ruby
  require 'factory_inspector`

  ...

  inspection_log = "#{File.dirname(__FILE__)}/../log/factory_inspector_report.txt" 
  factory_inspector = FactoryInspector.new(inspection_log)
  RSpec.configure do |config|
    ...
    config.before :suite do
      ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start_time, finish_time,>
        factory_inspector.analyze(payload[:name], start_time, finish_time, payload[:strategy])
      end
    end

    config.after :suite do
      factory_inspector.generate_report
      puts "Factory Inspector report in '#{factory_inspector.output_filename}'" 
    end
  end
```

Isn't this clumsy? I'll see if I can make more of it vanish inside the
Gem, especially the filename generation.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

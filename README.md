# FactoryInspector

This very simple gem reports on how FactoryGirl factories 
are being used during your test runs. This is useful in
understanding where the time is going during your test
runs.

This is a developer's tool; the Gem makes no effort to
sanitize inputs or help you avoid making mistakes. It
relies on the changes brought in with FactoryGirl 3.2:
    http://robots.thoughtbot.com/post/21719164760/factorygirl-3-2-so-awesome-it-needs-to-be-released

## Installation

Add this line to your application's Gemfile:

    gem 'factory_inspector'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install factory_inspector

## Usage

FactoryInspector should be instantiated with a filename to log
the report to, then it's hooked into FactoryGirl's notifications
inside your test configuration.

Let's take a hypothetical `spec/spec_helper.rb` on a RSpec based
project; the changes to use FactoryInspector would be:

```ruby
  require 'factory_inspector'


  inspection_log = "#{File.dirname(__FILE__)}/../log/factory_inspector_report.txt" 
  factory_inspector = FactoryInspector.new(inspection_log)
  RSpec.configure do |config|

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

After the tests have run, the nominated log file will have output
similar to this:

```
FACTORY INSPECTOR - 46 FACTORIES USED
  FACTORY NAME                TOTAL  OVERALL   TIME PER  LONGEST   STRATEGIES
                              CALLS  TIME (s)  CALL (s)  CALL (s)            
  school_with_terms             1    0.4783    0.47827  0.4783      [:create]
  school_with_terms_and_cla     5    2.3859    0.47718  0.5184      [:create]
  school_leaver                 1    0.2581    0.25808  0.2581      [:create]
  pre_enrolled_pupil            1    0.2570    0.25704  0.2570      [:create]
  pupil_school_enrolment_fo     1    0.2008    0.20075  0.2008      [:build]
  announcement                  5    0.8973    0.17946  0.2327      [:create]
  sub_class_with_pupils         5    0.7961    0.15921  0.2163      [:create, :build]
  etc
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

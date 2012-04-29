# FactoryInspector

This very simple gem reports on how FactoryGirl factories 
are being used during your test runs. This is useful in
understanding where the time is going during your test
runs - while FactoryGirl is useful, overuse can lead to
serious slowdowns to a cascade of database writes when
building a test object.

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

FactoryInspector's API is just two methods - `start_inspection` and `generate_report`. 

Let's take a hypothetical `spec/spec_helper.rb` on a RSpec based
project; the changes to use FactoryInspector would be:

```ruby
  require 'factory_inspector'

  # From a project relative filename like 'log/filename.txt'
  # generate the full path.
  # TODO There must be simpler way to do this?
  def get_project_path_for(filename)
    "#{File.dirname(__FILE__)}/../#{filename}"
  end

  factory_inspector = FactoryInspector.new
  RSpec.configure do |config|

    config.before :suite do
      factory_inspector.start_inspection
    end

    config.after :suite do
      report_name = 'log/factory_inspector_report.txt'
      report_path = get_project_path_for report_name 
      factory_inspector.generate_report report_path
      puts "Factory Inspector report in '#{report_name}'"
    end
  end
```

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

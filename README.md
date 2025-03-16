# A::NtiMannerKickCourse

## Introduction
Rails speeds up the startup process by lazily loading classes for components like ActiveRecord::Base and ActionController::Base. Additionally, the behavior of lazy loading is essential for applying configuration settings to these components. Without lazy loading, some configurations might not be applied as expected.

### Why Lazy Loading Matters
Without lazy loading, certain settings might not be applied in time.

For example, consider the following scenario:

### Example: Upgrading from Rails 7.0 to 7.1
When upgrading from Rails 7.0 to Rails 7.1, running rails app:upgrade generates a file named `config/initializers/new_framework_defaults_7_1.rb`. This file helps incrementally enable new default settings for Rails 7.1. Initially, all settings in this file are commented out. Uncommenting the following setting will enable it:

```ruby
###
# Do not treat an `ActionController::Parameters` instance
# as equal to an equivalent `Hash` by default.
#++
Rails.application.config.action_controller.allow_deprecated_parameters_hash_equality = false
```

### Configuration Details and Pitfalls
As the comment suggests, this setting ensures that ActionController::Parameters instances are no longer treated as equivalent to Hash. However, if ActionController::Base is eager-loaded, this configuration will not behave as expected. Why does this happen?

Configuration settings like `Rails.application.config.action_controller.allow_deprecated_parameters_hash_equality` are not automatically effective. These settings are applied to components like ActionController only during the Rails initialization process.

In this case, the value of `Rails.application.config.action_controller.allow_deprecated_parameters_hash_equality` is assigned to `ActionController::Parameters.allow_deprecated_parameters_hash_equality` during initialization, as seen in the following code:

```ruby
ActionController::Parameters.allow_deprecated_parameters_hash_equality = Rails.application.config.action_controller.allow_deprecated_parameters_hash_equality
```

Source: https://github.com/rails/rails/blob/36c1591bcb5e0ee3084759c7f42a706fe5bb7ca7/actionpack/lib/action_controller/railtie.rb#L51-L52

This assignment is wrapped in an `ActiveSupport.on_load(:action_controller, run_once: true) do ... end` block, ensuring that it runs only when ActionController::Base is loaded:

```ruby
ActiveSupport.on_load(:action_controller, run_once: true) do
  # Configuration assignment logic
end
```

Now, consider a gem "add_some_function_to_controller" with the following code:

```ruby
module AddSomeFunctionToController
# snip
end

ActionController::Base.include(AddSomeFunctionToController)
```

Since all gems listed in the Gemfile are required in config/application.rb, the above code causes ActionController::Base to be loaded during Rails initialization. The order of initialization typically looks like this:

1.	config/application.rb
2.	Component configuration logic (e.g., applying settings)
3.	Initializer files in config/initializers/*.rb

As a result, the configuration logic for ActionController is executed before the initializer file `config/initializers/new_framework_defaults_7_1.rb`. This means that the setting `Rails.application.config.action_controller.allow_deprecated_parameters_hash_equality = false` is not applied in time.

### Fixing the Issue
To solve this, modify the gem code as follows:

```ruby
module AddSomeFunctionToController
# snip
end

ActiveSupport.on_load(:action_controller) do
  ActionController::Base.include(AddSomeFunctionToController)
end
```

This ensures that ActionController::Base is loaded lazily, delaying the execution of the configuration logic to the correct timing. The updated order of initialization becomes:

1.	config/application.rb
2.	Initializer files in config/initializers/*.rb
3.	Component configuration logic

This resolves the issue, as the setting in config/initializers/new_framework_defaults_7_1.rb is now applied correctly.

While this specific case is likely a common issue, other problems may also arise from changes to the initialization order. To ensure reliable behavior, it is critical to keep all component loading deferred during Rails initialization. However, manually checking for potential issues with lazy loading is impractical.

### Using a-nti_manner_kick_course
Using a-nti_manner_kick_course can help detect libraries or application code (like add_some_function_to_controller) that interfere with lazy loading, allowing you to maintain proper initialization behavior.

## Installation

Add this line **at the top of your Gemfile**.

```ruby
gem "a-nti_manner_kick_course"
```

> [!IMPORTANT]
> To detect gems that fail to defer execution, you need to add this gem at the top of your Gemfile.

And then execute:
```bash
$ bundle
```

## Usage

Start your Rails application with the ANTI_MANNER environment variable as follows.

```bash
$ ANTI_MANNER=1 rails boot
```

If you are using Rails 7.1 or below, start the application as follows.

```bash
$ ANTI_MANNER=1 rails runner 1
```

If any code fails to lazy loading, the process will exit with status code 1. This command suggests which lines are eager loading Rails code. It is a good idea to regularly check in CI if lazy loading is working correctly.

You can fix the issue by wrapping the relevant code in an `ActiveSupport.on_load` block.

For more details about ActiveSupport.on_load, check [the official Rails documentation](https://api.rubyonrails.org/classes/ActiveSupport/LazyLoadHooks.html).

If the ANTI_MANNER environment variable is not set, this gem does nothing.

> [!CAUTION]
> If you are using Spring, this gem will not work correctly. In that case, add DISABLE_SPRING=1 to your command before running it.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

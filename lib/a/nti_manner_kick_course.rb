require "a/nti_manner_kick_course/version"
require "a/nti_manner_kick_course/railtie"

module A
  module NtiMannerKickCourse
    MONITORED_HOOKS =  %i[
      action_controller action_controller_base action_controller_api action_controller_test_case action_dispatch_response action_dispatch_integration_test
      message_pack active_model active_model_translation active_job active_job_test_case active_record_fixtures
      action_cable_connection action_cable_connection_test_case action_cable action_cable_channel action_cable_channel_test_case
      action_text_encrypted_rich_text action_text_record action_text_rich_text action_text_content active_record active_record_fixture_set
      active_record_sqlite3adapter active_record_mysql2adapter active_record_trilogyadapter active_record_postgresqladapter active_record_encryption
      action_view action_view_test_case action_mailer action_mailer_test_case active_storage_blog active_storage_record active_storage_variant_record
      active_storage_attachment action_mailbox_inbound_email action_mailbox_record action_mailbox action_mailbox_test_case
     ].freeze

    class << self
      def enabled?
        ENV["ANTI_MANNER"]
      end

      def debug?
        ENV["ANTI_MANNER_DEBUG"]
      end

      def monitor_rails_startup
        start_monitoring
        add_hooks
      end

      def monitor_gem
        start_monitoring
        add_hooks
        yield
        wrapup!
      end

      alias monitor monitor_gem

      def wrapup!
        A::NtiMannerKickCourse.finish_monitoring

        puts "✅Congratulations! No code was found that fails to defer execution!"
        exit
      end

      def monitoring?
        @monitoring
      end

      def finish_monitoring
        @monitoring = false
      end

      # TODO: We need to make this list more comprehensive.
      def filtering
        %r{<internal:|/bundled_gems.rb|/(a-nti_manner_kick_course|activemodel|activesupport|actionpack|activerecord|bootsnap|bundler|zeitwerk)-([0-9\.]+|[0-9a-z]{12})/}
      end

      def already_checked?
        @already_checked
      end

      def already_checked
        @already_checked = true
      end

      def error_message(framework)
        suspect = caller.find { |c| !A::NtiMannerKickCourse.filtering.match?(c) }
        <<~"MESSAGE"
          ❌During Rails startup, the block inside ActiveSupport.on_load(:#{framework}) was executed.
          There is code that is not being deferred as expected. The suspicious part is here.

          #{suspect}

          If you want to check the entire stack trace, set the ANTI_MANNER_DEBUG environment variable.
        MESSAGE
      end

      def error_message_with_debug(framework)
        <<~"MESSAGE"
          ❌During Rails startup, the block inside ActiveSupport.on_load(:#{framework}) was executed.
          There is code that is not being deferred as expected.

          Currently, debug mode is enabled, so the full stack trace is being displayed.
          To show only the suspicious code line, remove the ANTI_MANNER_DEBUG environment variable and rerun.

          #{caller}
        MESSAGE
      end

      private

      def start_monitoring
        @monitoring = true
      end

      def add_hooks
        require "active_support/lazy_load_hooks"

        MONITORED_HOOKS.each do |framework|
          ActiveSupport.on_load(framework) do
            if A::NtiMannerKickCourse.monitoring? && !A::NtiMannerKickCourse.already_checked?
              A::NtiMannerKickCourse.already_checked
              message = if A::NtiMannerKickCourse.debug?
                A::NtiMannerKickCourse.error_message_with_debug(framework)
              else
                A::NtiMannerKickCourse.error_message(framework)
              end

              abort(message)
            end
          end
        end
      end
    end

    monitor_rails_startup if enabled?
  end
end

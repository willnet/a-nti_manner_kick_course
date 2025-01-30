require "test_helper"
require "a/nti_manner_kick_course"
class UnitTest < ActiveSupport::TestCase
  test "filtering works correctly" do
    assert_match A::NtiMannerKickCourse.filtering, "/Users/willnet/.rbenv/versions/3.3.6/lib/ruby/gems/3.3.0/gems/activesupport-7.1.3.4/lib/active_support/lazy_load_hooks.rb:97:in `class_eval'"
    assert_match A::NtiMannerKickCourse.filtering, "/Users/willnet/.rbenv/versions/3.3.6/lib/ruby/gems/3.3.0/bundler/gems/activesupport-b7785b412d18/lib/active_support/lazy_load_hooks.rb:97:in `class_eval'"
    assert_no_match A::NtiMannerKickCourse.filtering, "/Users/willnet/.rbenv/versions/3.3.6/lib/ruby/gems/3.3.0/gems/activerecord-bitemporal-5.2.0/lib/activerecord-bitemporal/bitemporal.rb:299:in `block in <module:Persistence>'"
    assert_no_match A::NtiMannerKickCourse.filtering, "/Users/willnet/.rbenv/versions/3.3.6/lib/ruby/gems/3.3.0/gems/activerecord-bitemporal-5.2.0/lib/activerecord-bitemporal.rb:5:in `<main>'"
  end
end

require "test_helper"

class GemTest < ActiveSupport::TestCase
  def setup
    ENV["ANTI_MANNER_DEBUG"] = nil
  end

  test "A::NtiMannerKickCourse.monitor_gem exits with status code 1 when improper code is detected and anti manner is enabled" do
    pid = fork { require "a/nti_manner_kick_course"; A::NtiMannerKickCourse.monitor_gem {  require_relative "anti_manner_gem" } }
    status = Process::Status.wait(pid)
    assert_equal 1, status.exitstatus
  end

  test "A::NtiMannerKickCourse.monitor_gem exits with status code 0 when proper code is detected and anti_manner is enabled" do
    pid = fork {  require "a/nti_manner_kick_course"; A::NtiMannerKickCourse.monitor_gem { require "a/nti_manner_kick_course"; require_relative "good_manner_gem" } }
    status = Process::Status.wait(pid)
    assert_equal 0, status.exitstatus
  end

  test "A::NtiMannerKickCourse.monitor_gem exits with status code 1 when improper code is detected, anti manner is enabled, and debug is on" do
    ENV["ANTI_MANNER_DEBUG"] = "1"
    pid = fork { require "a/nti_manner_kick_course"; A::NtiMannerKickCourse.monitor_gem {  require_relative "anti_manner_gem" } }
    status = Process::Status.wait(pid)
    assert_equal 1, status.exitstatus
  end
end

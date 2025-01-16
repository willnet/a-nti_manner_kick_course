require "test_helper"

class A::NtiMannerKickCourseTest < ActiveSupport::TestCase
  def setup
    ENV["ANTI_MANNER"] = nil
    ENV["INJECT_ANTI_MANNER"] = nil
  end

  test "Rails exits with status code 1 when improper code is detected and anti manner is enabled" do
    ENV["ANTI_MANNER"] = "1"
    ENV["INJECT_ANTI_MANNER"] = "1"
    pid = fork { require "dummy/config/environment" }
    status = Process::Status.wait(pid)
    assert_equal 1, status.exitstatus
  end

  test "Rails exits with status code 0 when proper code is detected and anti_manner is enabled" do
    ENV["ANTI_MANNER"] = "1"
    pid = fork { require "dummy/config/environment" }
    status = Process::Status.wait(pid)
    assert_equal 0, status.exitstatus
  end

  test "Rails exits with status code 0 when improper code is detected but anti_manner is disabled" do
    ENV["INJECT_ANTI_MANNER"] = "1"
    pid = fork { require "dummy/config/environment" }
    status = Process::Status.wait(pid)
    assert_equal 0, status.exitstatus
  end
end

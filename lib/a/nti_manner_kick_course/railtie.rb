require "rails"

module A
  module NtiMannerKickCourse
    class Railtie < ::Rails::Railtie
      initializer "anti_manner", before: :eager_load! do
        if A::NtiMannerKickCourse.enabled?
          A::NtiMannerKickCourse.wrapup!
        end
      end
    end
  end
end

require "rails"

module A
  module NtiMannerKickCourse
    class Railtie < ::Rails::Railtie
      initializer "anti_manner", before: :eager_load! do
        if A::NtiMannerKickCourse.enabled?
          A::NtiMannerKickCourse.finish_monitoring

          puts "✅Congratulations! No code was found that fails to defer execution!"
          exit
        end
      end
    end
  end
end

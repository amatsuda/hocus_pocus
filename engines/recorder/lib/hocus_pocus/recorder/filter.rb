module HocusPocus
  module Recorder
    class Filter
      def self.before(controller)
#         (controller.flash[HocusPocus::Recorder::SPEC] ||= '') << controller.params.delete(HocusPocus::Recorder::SPEC) if controller.params[HocusPocus::Recorder::SPEC]
        controller.flash[HocusPocus::Recorder::SPEC] = controller.params.delete HocusPocus::Recorder::SPEC if controller.params[HocusPocus::Recorder::SPEC]
        controller.flash.keep HocusPocus::Recorder::SPEC
      end
    end
  end
end

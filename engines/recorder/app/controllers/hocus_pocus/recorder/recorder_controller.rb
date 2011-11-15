module HocusPocus
  module Recorder
    class RecorderController < ActionController::Base
      # XHR
      def index
        flash.keep HocusPocus::Recorder::SPEC
      end

      # XHR
      def destroy
        flash.discard HocusPocus::Recorder::SPEC
      end
    end
  end
end

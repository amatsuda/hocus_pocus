class SpecController < ActionController::Base
  # XHR
  def destroy
    flash.discard HocusPocus::SPEC
  end
end

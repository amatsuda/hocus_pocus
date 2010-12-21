module HocusPocus
  class EditorController < ActionController::Base
    # XHR
    def index
      #FIXME haml
      @path = "#{Rails.application.root}/app/views/#{params[:template]}.html.erb"
      @file = File.read @path
      #FIXME extract partials
    end

    # XHR
    def save
      @file = File.open(params[:path], 'w') do |f|
        f.puts params[:file]
      end
#       redirect_to "#{params[:uri]}", :notice => "successfully edited #{params[:path]} file!"
    end
  end
end

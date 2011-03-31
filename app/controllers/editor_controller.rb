class EditorController < ActionController::Base
  # XHR
  def index
    #FIXME should be done in more elegant way
    %w(haml erb).each do |format|
      @path = "#{Rails.application.root}/app/views/#{params[:template]}.html.#{format}"
      next unless File.exists? @path
      @file = File.read @path
      break
    end
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

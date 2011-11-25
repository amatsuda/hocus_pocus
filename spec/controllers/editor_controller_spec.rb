require "spec_helper"

describe HocusPocus::Editor::EditorController do
  let(:buffer_file) { Rails.root.to_s + "/../tmp_saved_buffer.rb" }
  let(:final_file_content) { "Writing files for dummies" }
  
  context "editing" do
    it "sets variables correctly" do
      # HocusPocus::Editor::EditorController maps to hocus_pocus/editor/editor, so we use
      # :use_route option to override that.
      get :index, { :template => "main/index", :use_route => :hocus_pocus_editor }
      assigns[:path].should == "#{Rails.application.root}/app/views/main/index.html.erb"
    end
  end
  
  context "saving" do
    it "writes into the file what was sent through post" do
      # creates a file with a default string
      File.open(buffer_file, "w") { |f| f.print "Banzai" }
      post :save, { :path => buffer_file, :file => final_file_content, :use_route => :hocus_pocus_editor }
      File.open(buffer_file, "r").read.should == final_file_content
      File.delete buffer_file
    end
  end
end
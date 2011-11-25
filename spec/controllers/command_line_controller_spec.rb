require "spec_helper"

describe HocusPocus::CommandLine::CommandLineController do
  let(:buffer_file) { Rails.root.to_s + "/../tmp_saved_buffer.rb" }
  
  context "executing" do
    it "runs command successfully" do
      File.open(buffer_file, "w") { |f| f.print "Banzai" }
      post :execute, { :execute => "rm -f "+buffer_file, :use_route => :hocus_pocus_command_line }
      File.exists?(buffer_file).should be_false
    end
  end
end
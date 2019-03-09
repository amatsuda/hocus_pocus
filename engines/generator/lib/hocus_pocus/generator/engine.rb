module HocusPocus
  module Generator
    class Engine < ::Rails::Engine
      isolate_namespace HocusPocus::Generator
      initializer 'hocus_pocus.recorder.add middleware' do |app|
        if HocusPocus.config.enable_generator
          config.assets.precompile += %w(generator.css)
        end
      end
    end
  end
end

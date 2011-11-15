require 'hocus_pocus/railtie'
#TODO see config
require 'hocus_pocus/editor/railtie'
require 'hocus_pocus/recorder/railtie'
# note that the generator should be loaded at the last because it has wildcard routing
require 'hocus_pocus/generator/railtie'

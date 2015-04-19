require 'rails/engine'

require 'lean_tag/tag'
require 'lean_tag/taggable'
require 'lean_tag/tagging'

module LeanTag
  class Engine < ::Rails::Engine

    isolate_namespace LeanTag

  end
end

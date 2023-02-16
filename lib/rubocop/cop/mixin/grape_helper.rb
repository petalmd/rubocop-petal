# frozen_string_literal: true

module RuboCop
  module Cop
    module Grape
      module GrapeHelper
        HTTP_ACTIONS = Set.new(%i[get head put post patch delete])
        NAMESPACE_ALIASES = %i[resource resources group segment].freeze
        AlL_NAMESPACE_METHODS = NAMESPACE_ALIASES + %i[namespace]
      end
    end
  end
end

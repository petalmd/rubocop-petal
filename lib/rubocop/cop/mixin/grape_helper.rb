# frozen_string_literal: true

module RuboCop
  module Cop
    module Grape
      module GrapeHelper
        HTTP_ACTIONS = Set.new(%i[get head put post patch delete])
        NAMESPACE_ALIASES = Set.new(%i[namespace resource resources group segment]).freeze
      end
    end
  end
end

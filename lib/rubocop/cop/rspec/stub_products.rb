# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Suggest to use stub_products instead of veil/unveil_product
      # which queries the database and can cause flaky tests.
      #
      #   # bad
      #   unveil_product('MY_PRODUCT')
      #   veil_product('MY_PRODUCT')
      #
      #   # good
      #   stub_products('MY_PRODUCT' => true)
      #   stub_products('MY_PRODUCT' => false)
      #   stub_products('MY_PRODUCT' => group)
      #   stub_products('MY_PRODUCT' => [group1, group2])
      #   stub_products(MY_PRODUCT: true)
      #
      class StubProducts < Base
        extend AutoCorrector

        MSG = 'Use `stub_products` instead of veil/unveil_product.'

        def_node_search :veil_product?, <<~PATTERN
          (send nil? :veil_product _)
        PATTERN

        def_node_search :unveil_product?, <<~PATTERN
          (send nil? :unveil_product _)
        PATTERN

        def on_send(node)
          return unless veil_product?(node) || unveil_product?(node)

          add_offense(node) do |corrector|
            product_is_available = !veil_product?(node)
            subst = "stub_products(\\k<product> => #{product_is_available}"

            corrector.replace(node, node.source.gsub(/(?'method'^[^(]*).(?'product'[^)]+)/m, subst))
          end
        end
      end
    end
  end
end

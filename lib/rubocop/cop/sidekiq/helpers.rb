# frozen_string_literal: true

# credit: https://github.com/dvandersluis/rubocop-sidekiq/blob/master/lib/rubocop/cop/helpers.rb
module RuboCop
  module Cop
    module Sidekiq
      module Helpers
        NODE_MATCHERS = lambda do
          def_node_matcher :sidekiq_include?, <<~PATTERN
            (send nil? :include (const (const {nil? cbase} :Sidekiq) {:Worker :Job}))
          PATTERN

          def_node_matcher :includes_sidekiq?, <<~PATTERN
            {
              (begin <#sidekiq_include? ...>)
              #sidekiq_include?
            }
          PATTERN

          def_node_matcher :worker_class_def?, <<~PATTERN
            (class _ _ #includes_sidekiq?)
          PATTERN

          def_node_matcher :worker_anon_class_def?, <<~PATTERN
            (block (send (const nil? :Class) :new ...) _ #includes_sidekiq?)
          PATTERN

          def_node_matcher :worker_class_application_worker?, <<~PATTERN
            (class _ (const {nil? cbase} :ApplicationWorker) ...)
          PATTERN

          def_node_matcher :worker_anon_class_application_worker_def?, <<~PATTERN
            (block (send (const nil? :Class) :new (const {nil? cbase} :ApplicationWorker)) ...)
          PATTERN

          def_node_matcher :sidekiq_worker?, <<~PATTERN
            {#worker_class_def? #worker_anon_class_def? #worker_class_application_worker? #worker_anon_class_application_worker_def?}
          PATTERN

          def_node_matcher :sidekiq_perform?, <<~PATTERN
            (send const ${:perform_async :perform_in :perform_at} ...)
          PATTERN
        end

        def self.included(klass)
          klass.class_exec(&NODE_MATCHERS)
        end

        def in_sidekiq_worker?(node)
          node.each_ancestor(:class, :block).detect { |anc| sidekiq_worker?(anc) }
        end

        def sidekiq_arguments(node, &block)
          return [] unless node.send_type? && (method_name = sidekiq_perform?(node))
          return enum_for(:sidekiq_arguments, node) unless block

          # Drop the first argument for perform_at and perform_in
          expand_nodes(method_name == :perform_async ? node.arguments : node.arguments[1..], &block)
        end

        def expand_nodes(nodes, &block)
          return enum_for(:expand_nodes, nodes) unless block

          nodes.each { |node| expand_node(node, &block) }
        end

        def expand_node(node, &block)
          return enum_for(:expand_node, node) unless block

          expand_hash_array_node(node, &block) || yield(node)
        end

        def expand_hash_array_node(node, &block)
          expand_hash_node(node, &block) || expand_array_node(node, &block)
        end

        def expand_hash_node(node, &block)
          return unless node.hash_type?
          return enum_for(:expand_hash_node, node) unless block

          node.pairs.each do |pair_node|
            expand_hash_array_node(pair_node.key, &block) ||
              expand_hash_array_node(pair_node.value, &block) ||
              yield(pair_node)
          end
        end

        def expand_array_node(node, &block)
          return unless node.array_type?
          return enum_for(:expand_array_node, node) unless block

          if node.square_brackets?
            expand_nodes(node.values, &block)
          else
            yield node
          end
        end

        def node_approved?(node)
          @approved_nodes ||= []
          @approved_nodes.any? { |r| within?(node.source_range, r) }
        end
        alias node_denied? node_approved?

        def approve_node(node)
          @approved_nodes ||= []
          @approved_nodes << node.source_range
        end
        alias deny_node approve_node

        def within?(inner, outer)
          inner.begin_pos >= outer.begin_pos && inner.end_pos <= outer.end_pos
        end
      end
    end
  end
end

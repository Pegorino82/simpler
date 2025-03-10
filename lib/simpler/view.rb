# frozen_string_literal: true

require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'

    def initialize(env)
      @env = env
    end

    def render(binding)
      return plain if plain?

      template = File.read(template_path)
      ERB.new(template).result(binding)
    end

    private

    def plain?
      template.is_a?(Hash) && template.key?(:plain)
    end

    def plain
      template[:plain]
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end

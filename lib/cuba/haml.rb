require 'tilt'
require 'tilt/haml'

class Cuba
  module Haml
    def self.setup(app)
      app.settings[:haml] ||= {}
      app.settings[:haml][:views] ||= File.expand_path("views", Dir.pwd)
      app.settings[:haml][:layout_path] ||= app.settings[:haml][:views]
      app.settings[:haml][:layout] ||= "layout"
      app.settings[:haml][:options] ||= {
        default_encoding: Encoding.default_external
      }
    end

    # Use default layout
    def haml(template, locals = {})
      res.write render(layout_path,
                { content: partial(template, locals) }.merge(locals),
                settings[:haml][:options])
    end

    # Use specific layout file nested into :layout_path
    def view(template, layout_file, options = {})
      layout = File.expand_path(layout_file, settings[:haml][:layout_path])
      res.write partial(layout,
                        { content: partial(template, locals) }.merge(locals))
    end

    # Skip layout, only renders the template
    def partial(template, locals = {})
      render(template_path(template), locals, settings[:haml][:options])
    end

    # @private Used internally by #render to cache the Tilt templates.
    def _cache
      Thread.current[:_cache] ||= Tilt::Cache.new
    end

    private :_cache

    def template_path(template)
      "%s/%s.haml" % [
        settings[:haml][:views],
        template
      ]
    end

    def layout_path
      "%s/%s.haml" % [
        settings[:haml][:layout_path],
        settings[:haml][:layout]
      ]
    end

    # Render any type of template file supported by Tilt.
    #
    # @example
    #
    #   # Renders home, and is assumed to be HAML.
    #   render("home")
    #
    #   # Renders with some local variables
    #   render("home", site_name: "My Site")
    #
    #   # Renders with HAML options
    #   render("home", {}, ugly: true, format: :html5)
    #
    #   # Renders in layout
    #   render("layout.haml") { render("home.haml") }
    #
    def render(template, locals = {}, options = {}, &block)
      _cache.fetch(template) {
        Tilt.new(template, 1, options.merge(outvar: '@_output'))
      }.render(self, locals, &block)
    end
  end
end

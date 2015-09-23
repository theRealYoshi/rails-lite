require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      class_name = self.class.to_s.underscore.downcase
      template = ERB.new(File.read("views/#{class_name}/#{template_name}.html.erb"))
      content = template.result(binding)
      render_content(content, "text/html")
    end
  end
end

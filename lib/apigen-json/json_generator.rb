require 'apigen/generation/generator.rb'
require 'mustache'

class JsonGenerator < Generator

  def generate(endpoint_group, opts={})
    template = get_template
    return Mustache.render(template, endpoint_group)
  end

  def get_template
    File.read("#{__dir__}/template.mustache")
  end
end

require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
# require 'active_support'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "already set" if @already_built_response
    Session.new(req).store_session(res)
    @already_built_response = true
    res.status = 302
    res['location'] = url
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "already set" if @already_built_response
    Session.new(req).store_session(res)
    @already_built_response = true
    res['Content-Type'] = content_type
    res.write(content)
    nil
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    f = File.read("views/cats_controller/#{template_name}.html.erb")
    # f = File.read("views/#{underscore(self.class)}/#{template_name}.html.erb")
    # f = File.read("/Users/byronhan/Documents/GitHub/aa_w8d1/skeleton/views/cats_controller/#{template_name}.html.erb")
    content = ERB.new(f).result(binding)
    render_content(content, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req).store_session(res)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

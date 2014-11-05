require 'apigen/generation/generator.rb'
require 'mustache'
require 'json'

class JsonGenerator < Generator

  def generate(endpoint_group, opts={})
    get_endpoint_group_hash(endpoint_group).to_json
  end

  def get_endpoint_group_hash(endpoint_group)
    endpoint_group.endpoints.map do |endpoint|
      get_endpoint_hash(endpoint)
    end
  end

  # converts an Endpoint to a Hash
  def get_endpoint_hash(endpoint)
    {
      :name => endpoint.name,
      :url => endpoint.url,
      :method => {
        :name => endpoint.method.name,
        :has_body => endpoint.method.has_body
      },
      :request_type => endpoint.request_type,
      :path_params => get_path_params_hash(endpoint.path_params),
      :query_params => get_query_params_hash(endpoint.query_params),
      :headers => get_headers_hash(endpoint.headers),
      :request_params => get_request_params_hash(endpoint.request_params)
    }
  end

  # converts a PathParam map to a Hash
  def get_path_params_hash(path_params)
    path_params.values.map do |path_param|
      get_hash(path_param, [:name, :type])
    end
  end

  # converts a QueryParam map to a Hash
  def get_query_params_hash(query_params)
    query_params.values.map do |query_param|
      get_hash(query_param, [:name, :type])
    end
  end

  # converts a Header map to a Hash
  def get_headers_hash(headers)
    headers.values.map do |header|
      get_hash(header, [:name, :value])
    end
  end

  # converts a RequestParam map to a Hash
  def get_request_params_hash(request_params)
    # TODO implement this
    []
  end

  # given an object an a list of sym, this method
  # return a hash mapping arg[i] to method call of obj.arg[i]
  #
  # Example args = [:a, :b, :method]
  #
  # The resulting hash will be
  # {
  #   :a => obj.a,
  #   :b => obj.b,
  #   :method => obj.method
  # }
  #
  def get_hash(obj, args)
    hash = {}
    args.each do |arg|
      val = obj.send(arg)
      hash[arg] = val
    end
    return hash
  end
end

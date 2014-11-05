require 'minitest/autorun'
require 'apigen/endpoint'
require 'apigen/path_param'
require 'apigen-json/json_generator.rb'

describe 'JsonGenerator' do

  def as_hash(*has_names)
    hash = {}
    has_names.each do |has_name|
      hash[has_name.name] = has_name
    end
    return hash
  end

  before :each do
    @generator = JsonGenerator.new
    @endpoint = Endpoint.new name: 'fee', url: 'foo/bar', method: HttpMethod.put
    @endpoint_hash = @generator.get_endpoint_hash @endpoint

    # construct to path params
    @path_param_a = PathParam.new name: 'foo'
    @path_param_b = PathParam.new name: 'baz'
    @path_params = as_hash(@path_param_a, @path_param_b)

    # Create two Classes. Struct.new returns a 'Class' object
    # with getters and setters for the given arguments
    @class_a = Struct.new :some, :method
    @class_b = Struct.new :a,:b,:c
  end

  describe 'get_endpoint_group_hash' do

    describe 'get_endpoint_hash' do

      it 'should convert an endpoint to a hash' do
        @endpoint_hash[:name].must_equal 'fee'
        @endpoint_hash[:url].must_equal 'foo/bar'
        @endpoint_hash[:method][:name].must_equal :put
        @endpoint_hash[:method][:has_body].must_equal true
        @endpoint_hash[:request_type].must_equal @endpoint.request_type
      end

      [:query_params, :headers, :path_params, :request_params].each do |val|
        it "#{val} key should be empty" do
          @endpoint_hash[val].must_equal Array.new
        end
      end
    end

    describe 'get_path_params_hash' do
      it 'should convert empty hash to empty array' do
        res = @generator.get_path_params_hash({})
        res.must_equal []
      end

      it 'should convert path params hash to array' do
        res = @generator.get_path_params_hash @path_params
        res.size.must_equal 2
        res.first[:name].must_equal 'foo'
        res.last[:name].must_equal 'baz'
      end
    end

    describe 'get_query_params_hash' do
      # TODO
    end

    describe 'get_hash' do

      it "converts method calls to hash keys" do
        m = @class_a.new 'foo', 'bar'
        hash = @generator.get_hash m, [:some, :method]
        hash.size.must_equal 2
        hash[:some].must_equal m.some
        hash[:method].must_equal m.method
      end

      it "returns a hash with the given keys" do
        m = @class_b.new 'some','foo','method'
        hash = @generator.get_hash m, [:a, :b, :c]
        hash.size.must_equal 3
      end

      it "should return emptyhash when no keys given" do
        hash = @generator.get_hash @class_b.new, []
        hash.must_equal Hash.new
      end
    end

  end

end

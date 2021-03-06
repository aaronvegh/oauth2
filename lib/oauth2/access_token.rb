module OAuth2
  class AccessToken
    attr_reader :client, :token, :refresh_token, :expires_in, :expires_at, :instance_url
    attr_accessor :token_param

    def initialize(client, token, refresh_token = nil, expires_in = nil, instance_url = nil, params = {})
      @client = client
      @token = token.to_s
      @refresh_token = refresh_token.to_s
      @instance_url = instance_url.to_s
      @expires_in = (expires_in.nil? || expires_in == '') ? nil : expires_in.to_i
      @expires_at = Time.now + @expires_in if @expires_in
      @params = params
      @token_param = 'access_token'
    end

    def [](key)
      @params[key]
    end

    # True if the token in question has an expiration time.
    def expires?
      !!@expires_in
    end

    def request(verb, path, params = {}, headers = {})
      params = params.merge token_param => @token
      headers = headers.merge 'Authorization' => "OAuth #{@token}"
      @client.request(verb, path, params, headers)
    end

    def get(path, params = {}, headers = {})
      request(:get, path, params, headers)
    end

    def post(path, params = {}, headers = {})
      request(:post, path, params, headers)
    end

    def put(path, params = {}, headers = {})
      request(:put, path, params, headers)
    end

    def delete(path, params = {}, headers = {})
      request(:delete, path, params, headers)
    end
  end
end

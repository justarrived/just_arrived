# frozen_string_literal: true
require 'httparty'

module FrilansFinansApi
  class Request
    USER_AGENT = {
      'User-Agent' => 'FrilansFinansAPI - Ruby client'
    }.freeze

    HEADERS = {
      'Content-Type' => 'application/json'
    }.merge!(USER_AGENT).freeze

    GRANT_TYPE = 'client_credentials'

    attr_reader :credentials, :base_uri, :access_token

    def initialize(base_uri: nil, client_id: nil, client_secret: nil)
      @base_uri = base_uri || FrilansFinansApi.base_uri
      @credentials = {
        grant_type: GRANT_TYPE,
        client_id: client_id || FrilansFinansApi.client_id,
        client_secret: client_secret || FrilansFinansApi.client_secret
      }
      @access_token = nil
    end

    def get(uri:, query: {})
      authorized_request do
        _get(uri: uri, query: query)
      end
    end

    def post(uri:, query: {}, body: {})
      authorized_request do
        _post(uri: uri, query: query, body: body.to_json)
      end
    end

    def patch(uri:, query: {}, body: {})
      authorized_request do
        _patch(uri: uri, query: query, body: body)
      end
    end

    def _get(uri:, query: {})
      opts = build_get_opts(query: query)
      HTTParty.get("#{base_uri}#{uri}", opts)
    end

    def _post(uri:, query: {}, body: {})
      opts = build_post_opts(query: query, body: body)
      HTTParty.post("#{base_uri}#{uri}", opts)
    end

    def _patch(uri:, query: {}, body: {})
      opts = build_post_opts(query: query, body: body)
      HTTParty.patch("#{base_uri}#{uri}", opts)
    end

    private

    def build_get_opts(query: {})
      { query: query }.merge(headers: headers)
    end

    def build_post_opts(query: {}, body: {})
      {
        query: query,
        body: body
      }.merge(headers: headers)
    end

    def headers
      HEADERS.merge(auth_headers)
    end

    def authorized_request
      fetch_access_token if access_token.nil?

      response = yield
      return response unless reauthorize?(response)

      fetch_access_token
      yield
    end

    def reauthorize?(response)
      response.code == '401'
    end

    def auth_headers
      { 'Authorization' => "Bearer #{access_token}" }
    end

    def fetch_access_token
      response = HTTParty.post(
        "#{base_uri}/auth/accesstoken",
        body: credentials,
        headers: USER_AGENT
      )
      @access_token = extract_access_token(response)
      response
    end

    def extract_access_token(response)
      parsed = response.parsed_response

      # In tests HTTParty and Webmock aren't friends, causing HTTParty to return a string
      # from #parsed_response instead of a Hash
      parsed = JSON.parse(parsed) if parsed.is_a?(String)

      parsed['access_token']
    end
  end
end

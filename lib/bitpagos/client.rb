module Bitpagos
  class Client
    PENDING = "PE".freeze
    WAITING = "WA".freeze
    COMPLETED = "CO".freeze
    PARTIALLY_PAID = "PP".freeze
    API_BASE = "https://www.bitpagos.com/api/v1".freeze

    attr_accessor :headers, :api_base

    def initialize(api_key)
      if api_key.to_s.empty?
        raise Bitpagos::Errors::InvalidApiKey.new("No API key provided")
      end

      @api_key = "ApiKey #{api_key}".freeze
      @headers = { authorization: @api_key, content_type: :json, accept: :json }
      @api_base = API_BASE
    end

    def get_transaction(transaction_id)
      retrieve_transactions(nil, transaction_id)
    end

    def all_transactions
      retrieve_transactions
    end

    def completed_transactions
      retrieve_transactions(COMPLETED)
    end

    def waiting_transactions
      retrieve_transactions(WAITING)
    end

    def pending_transactions
      retrieve_transactions(PENDING)
    end

    def partially_paid_transactions
      retrieve_transactions(PARTIALLY_PAID)
    end

    private

    def retrieve_transactions(query = nil, transaction_id = nil)
      url = "#{API_BASE}/transaction/#{transaction_id}"
      RestClient.get(url, headers)
    end
  end
end

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

    # Retrieve all transactions, or specify them with parameters, to retrieve
    # allow retrieving paginated transactions.
    #
    # @param [Hash] Allows to specify transaction type, limit or offset
    # @option [Symbol] status (:pending, :waiting, :completed, :partially_paid)
    # @option [Integer] offset
    # @option [Integer] limit
    # @return [Hash]
    def transactions(params = {})
      if status = params[:status]
        params[:status] = get_transaction_type_from_symbol(status)
      end
      retrieve_transactions(params)
    end

    def completed_transactions
      retrieve_transactions(status: COMPLETED)
    end

    def waiting_transactions
      retrieve_transactions(status: WAITING)
    end

    def pending_transactions
      retrieve_transactions(status: PENDING)
    end

    def partially_paid_transactions
      retrieve_transactions(status: PARTIALLY_PAID)
    end

    # Returns the total count of transactions in all states.
    #
    # @return [Integer] Total transaction count
    def transaction_count
      transactions["meta"]["total_count"]
    end

    private

    # Takes a symbol and returns the proper transaction type.
    #
    # @param [Symbol] Can be :pending, :waiting, :completed or :partially_paid
    # @return [String,nil] Returns the corresponding "PE", "WA", "CO" or "PP"
    def get_transaction_type_from_symbol(transaction_type)
      begin
        target_type = transaction_type.to_s.upcase
        return if target_type.empty?
        self.class.const_get(target_type)
      rescue NameError => error
        raise Bitpagos::Errors::InvalidTransactionType.new(error.message)
      end
    end

    # Hits the Bitpagos transaction API, returns a hash with results
    #
    # @param [String] State (Pending, Waiting, Completed, Partially Paid)
    # @param [String] Transaction ID
    # @return [Hash]
    def retrieve_transactions(query = nil, transaction_id = nil)
      headers.merge!(params: query) if query
      url = "#{API_BASE}/transaction/#{transaction_id}"
      begin
        response = RestClient.get(url, headers)
        JSON.parse(response)
      rescue RestClient::Unauthorized => error
        raise Bitpagos::Errors::Unauthorized.new(error.message)
      end
    end
  end
end

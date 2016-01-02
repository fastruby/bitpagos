require 'spec_helper'

RSpec.describe Bitpagos::Client do
  subject { described_class.new(api_key) }
  let(:api_key) { "4141414141414" }

  describe "#new" do
    context "API key provided is blank" do
      let(:api_key) { "" }
      it "raises an InvalidApiKey error" do
        expect { subject }.to raise_exception(Bitpagos::Errors::InvalidApiKey)
      end
    end

    context "API key provided is nil" do
      let(:api_key) { nil }
      it "raises an InvalidApiKey error" do
        expect { subject }.to raise_exception(Bitpagos::Errors::InvalidApiKey)
      end
    end

    context "no API key is provided" do
      subject { described_class.new }
      it "raises an ArgumentError error" do
        expect { subject }.to raise_exception(ArgumentError)
      end
    end

    context "API key provided is invalid" do
      let(:api_key) { "OMGSARASA" }
      let(:exception) { Bitpagos::Errors::Unauthorized }

      it "returns a 401 code" do
        VCR.use_cassette("unauthorized_request") do
          expect { subject.all_transactions }.to raise_exception(exception)
        end
      end
    end

    context "valid API key is provided" do
      let(:api_key) { "ABCDEFGHIJK1234567890" }

      it "doesn't raise any errors" do
        expect { subject }.not_to raise_exception
      end

      it "generates the headers correctly" do
        expected_headers = { authorization: "ApiKey #{api_key}",
          content_type: :json, accept: :json }

        expect(subject.headers).to eq(expected_headers)
      end
    end
  end

  describe "#all_transactions" do
    it "returns all the transactions in a hash" do
      VCR.use_cassette("all_transactions") do
        result = subject.all_transactions
        expect(result).to be_a Hash
      end
    end

    it "returns all the transactions within the objects key" do
      VCR.use_cassette("all_transactions") do
        result = subject.all_transactions
        expect(result["objects"].size).to eq 20
      end
    end

    it "returns transaction data for each transaction in the objects array" do
      first_expected_hash = { "amount" => 424.0, "btc" => "0.07980400" }
      second_expected_hash = { "amount" => 494.0, "btc" => "0.09296200" }
      VCR.use_cassette("all_transactions") do
        result = subject.all_transactions
        expect(result["objects"][0]).to include first_expected_hash
        expect(result["objects"][1]).to include second_expected_hash
      end
    end
  end

  describe "#transaction_count" do
    it "returns the transaction count" do
      VCR.use_cassette("all_transactions") do
        result = subject.transaction_count
        expect(result).to eq 4408
      end
    end
  end

  describe "#get_transaction" do
    let(:transaction_id) { "dSC7qcJR2k8JfEK6r4sXPa" }

    it "returns the given transaction" do
      VCR.use_cassette("get_transaction") do
        result = subject.get_transaction(transaction_id)

        expect(result["amount"]).to eq 424.0
        expect(result["txn_id"]).to eq transaction_id
        expect(result["status"]).to eq "WA"
      end
    end
  end

  describe "#waiting_transactions" do
    let(:waiting_code) { Bitpagos::Client::WAITING }
    it "returns all transactions in waiting status" do
      VCR.use_cassette("waiting_transactions") do
        result = subject.waiting_transactions

        expect(result["objects"]).to all(include('status' => waiting_code))
      end
    end
  end

  describe "#completed_transactions" do
    let(:completed_code) { Bitpagos::Client::COMPLETED }
    it "returns all transactions in completed status" do
      VCR.use_cassette("completed_transactions") do
        result = subject.completed_transactions

        expect(result["objects"]).to all(include('status' => completed_code))
      end
    end

    it "shows the transaction type used to complete the transaction" do
      VCR.use_cassette("completed_transactions") do
        result = subject.completed_transactions

        expect(result["objects"][0]["txn_type"]).to eq("BTC")
      end
    end
  end
end

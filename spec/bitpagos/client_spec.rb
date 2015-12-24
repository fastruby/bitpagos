require 'spec_helper'

RSpec.describe Bitpagos::Client do
  describe "#new" do
    subject { described_class.new(api_key) }

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
end

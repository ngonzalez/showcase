require 'rails_helper'

RSpec.describe EncryptHelpers, :type => :class do
  let(:str) { "{session:15}" }
  let(:str_encrypt) { "76fc853de6ae47192be799bf165c9106:69b7a12a308a3f6ee7efff4fbbecaa29" }

  describe ".decrypt" do
    it "decrypts a known value" do
      expect(EncryptHelpers.decrypt(str_encrypt)).to eq(str)
    end

    it "raises ArgumentError unless given a String" do
      expect { EncryptHelpers.decrypt(nil) }.to raise_error(ArgumentError)
    end

    it "raises OpenSSL::Cipher::CipherError for a tampered value" do
      iv, encrypted = str_encrypt.split(":")
      tampered = [iv, encrypted.reverse].join(":")
      expect { EncryptHelpers.decrypt(tampered) }.to raise_error(OpenSSL::Cipher::CipherError)
    end
  end

  describe ".encrypt" do
    it "returns the IV and the encrypted value as hex" do
      expect(EncryptHelpers.encrypt(str)).to match(/\A\h{32}:\h+\z/)
    end

    it "round-trips with .decrypt" do
      expect(EncryptHelpers.decrypt(EncryptHelpers.encrypt(str))).to eq(str)
    end

    it "round-trips an empty String" do
      expect(EncryptHelpers.decrypt(EncryptHelpers.encrypt(""))).to eq("")
    end

    it "uses a random IV" do
      expect(EncryptHelpers.encrypt(str)).not_to eq(EncryptHelpers.encrypt(str))
    end

    it "raises ArgumentError unless given a String" do
      expect { EncryptHelpers.encrypt(15) }.to raise_error(ArgumentError)
    end
  end

  describe "with a key" do
    let(:key) { "0123456789abcdef0123456789abcdef" }

    it "decrypts a known value" do
      expect(EncryptHelpers.decrypt("b61325a02fabe53aa0dce3dcc564c513:1bbe06db857c443b15a1114cfaaa7fd2", key: key)).to eq(str)
    end

    it "round-trips with the same key" do
      expect(EncryptHelpers.decrypt(EncryptHelpers.encrypt(str, key: key), key: key)).to eq(str)
    end

    it "can't be decrypted with SECRET_KEY_BASE" do
      decrypted = begin
        EncryptHelpers.decrypt(EncryptHelpers.encrypt(str, key: key))
      rescue OpenSSL::Cipher::CipherError
        nil
      end
      expect(decrypted).not_to eq(str)
    end

    it "raises ArgumentError for a key that isn't 32 bytes" do
      expect { EncryptHelpers.encrypt(str, key: "short") }.to raise_error(ArgumentError)
    end
  end
end

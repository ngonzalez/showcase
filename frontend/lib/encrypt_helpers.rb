require 'openssl'

# Copyright (c) Nicolas GONZALEZ
# EncryptHelpers
#-
class EncryptHelpers

  # AES-256-CBC Encryption
  # @param str [String] String to encrypt
  # @return [String] the String encrypted
  def self.encrypt(str)
    raise ArgumentError unless str.is_a?(String)
    iv = OpenSSL::Random.random_bytes(16)
    key = SECRET_KEY_BASE[0, 32]
    cipher = OpenSSL::Cipher.new('aes-256-cbc').encrypt
    cipher.key = key
    cipher.iv = iv
    encrypted = cipher.update(str) + cipher.final
    "#{iv.unpack1('H*')}:#{encrypted.unpack1('H*')}"
  end

  # AES-256-CBC Decryption
  # @param str [String] String to decrypt
  # @return [String] the String decrypted
  def self.decrypt(str)
    raise ArgumentError unless str.is_a?(String)
    iv_hex, encrypted_hex = str.split(":")
    iv = [iv_hex].pack("H*")
    key = SECRET_KEY_BASE[0, 32]
    cipher = OpenSSL::Cipher.new('aes-256-cbc').decrypt
    cipher.key = key
    cipher.iv = iv
    decrypted = cipher.update([encrypted_hex].pack("H*")) + cipher.final
    decrypted
  end
end

# The user details travel between the registration pages encrypted with
# EncryptHelpers, so the password never appears in clear in URLs or in HTML.
module UserPayloadConcern
  extend ActiveSupport::Concern

  DECRYPT_ERRORS = [
    ArgumentError,
    TypeError,
    EncodingError,
    OpenSSL::Cipher::CipherError,
    JSON::ParserError,
  ].freeze

  private

  def encrypt_user_payload(attributes)
    EncryptHelpers.encrypt(attributes.to_json)
  end

  # nil for any invalid payload: responses must not reveal why decryption
  # failed (AES-CBC padding errors would otherwise act as a padding oracle)
  def decrypt_user_payload(payload)
    attributes = JSON.parse(EncryptHelpers.decrypt(payload), symbolize_names: true)
    attributes if attributes.is_a?(Hash)
  rescue *DECRYPT_ERRORS
    nil
  end
end

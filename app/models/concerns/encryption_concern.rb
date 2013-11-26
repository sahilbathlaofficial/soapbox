require 'securerandom'
require 'digest/sha1'


module EncryptionConcern

  class Encrypt
    extend ActiveSupport::Concern

    def initialize(key)
      @salt= key
    end

    def encrypt(text)
       Digest::SHA1.hexdigest("--#{@salt}--#{text}--")
    end
  end

end

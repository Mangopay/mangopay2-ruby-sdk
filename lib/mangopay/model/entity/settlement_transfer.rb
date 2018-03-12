require_relative 'transfer'
require_relative '../../common/jsonifier'

module MangoModel

  # Settlement Transfer entity
  # A Settlement Transfer is a transfer that can be used to settle
  # the credit from a repudiation following a lost dispute (to impact
  # the balance of the original wallet and settle the credit in your
  # client credit wallet).
  class SettlementTransfer < Transfer
    include MangoPay::Jsonifier

    # [String] ID of the associated repudiation transaction
    attr_accessor :repudiation_id
  end
end
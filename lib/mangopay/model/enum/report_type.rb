require_relative '../../util/enum'

module MangoModel

  # Report types enumeration
  class ReportType
    extend Enum

    TRANSACTIONS = value 'TRANSACTIONS'

    WALLETS = value 'WALLETS'
  end
end
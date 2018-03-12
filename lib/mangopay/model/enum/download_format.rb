require_relative '../../util/enum'

module MangoModel

  # Download formats enumeration
  class DownloadFormat
    extend Enum

    CSV = value 'CSV'
  end
end
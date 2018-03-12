require_relative '../../common/jsonifier'

module MangoModel

  # Report entity
  # The Report object enables possibility to download huge lists of
  # transactions or wallets to CSV form for accounting and analysis
  # purposes.
  class Report < EntityBase
    include MangoPay::Jsonifier

    # [Integer] Time when the report was executed (UNIX timestamp)
    attr_accessor :report_date

    # [String] URL where the report can be downloaded
    attr_accessor :download_url

    # [String] URL which MangoPay will ping once the report is ready
    # to be downloaded (works in a similar way to +Hook+s)
    attr_accessor :callback_url

    # [DownloadFormat] The format of the downloadable report
    attr_accessor :download_format

    # [ReportType] The type of report
    attr_accessor :report_type

    # [ReportStatus] Its status
    attr_accessor :status

    # [String] The column to sort by and the direction, separated
    # by a ':' character (i.e. CreationDate:DESC)
    attr_accessor :sort

    # [true/false] Whether the report should be limited to the first
    # 10 rows, making its execution faster
    attr_accessor :preview

    # [ReportFilter] Object which allows filtering of report entries
    attr_accessor :filters

    # [Array] List of names of the columns to be included in the report
    attr_accessor :columns

    # [String] The result code
    attr_accessor :result_code

    # [String] Explanation of the result
    attr_accessor :result_message
  end
end
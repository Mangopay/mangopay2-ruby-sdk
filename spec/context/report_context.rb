require_relative '../../lib/mangopay/model/entity/report'
require_relative '../../lib/mangopay/api/service/reports'

shared_context 'report_context' do

  REPORT_DATA ||= build_report
  REPORT_PERSISTED ||= persist_report REPORT_DATA
end

def persist_report(report)
  MangoApi::Reports.create_for_transactions report
end

def build_report
  report = MangoModel::Report.new
  report.callback_url = 'http://www.my-site.com/callbackURL/'
  report.download_format = MangoModel::DownloadFormat::CSV
  report.sort = 'CreationDate:DESC'
  report.preview = false
  report.columns = %w[Id CreationDate]
  report
end
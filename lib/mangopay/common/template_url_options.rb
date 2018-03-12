require_relative 'jsonifier'


class TemplateUrlOptions
  include MangoPay::Jsonifier

  # [String] URL to a SSL page
  attr_accessor :payline
end
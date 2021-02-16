require_relative '../common/jsonifier'

module MangoModel

  # Object that represents the browser info
  class BrowserInfo
    include MangoPay::Jsonifier

    # [String] Accept Header
    attr_accessor :accept_header

    # [Boolean] Java Enabled
    attr_accessor :java_enabled

    # [Boolean] Javascript Enabled
    attr_accessor :javascript_enabled

    # [String] Language
    attr_accessor :language

    # [String] ColorDepth
    attr_accessor :color_depth

    # [String] ScreenHeight
    attr_accessor :screen_height

    # [String] ScreenWidth
    attr_accessor :screen_width

    # [String] TimeZoneOffset
    attr_accessor :timezone_offset

    # [String] UserAgent
    attr_accessor :user_agent
  end
end
module MangoPay
  # Provides API methods for the UBO entity.
  class Regulatory < Resource
    class << self
      def one_country_url(country_iso)
        "#{MangoPay.api_path_no_client}/countries/#{country_iso}/authorizations"
      end

      def all_countries_url
        "#{MangoPay.api_path_no_client}/countries/authorizations"
      end

      def get_country_authorizations(country_iso)
        MangoPay.request(:get, one_country_url(country_iso))
      end

      def get_all_countries_authorizations
        MangoPay.request(:get, all_countries_url)
      end
    end
  end
end

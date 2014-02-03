class MapLayer < ActiveRecord::Base

  self.table_name = 'map_dataset_options'

  belongs_to :dataset
  has_and_belongs_to_many :maps, :join_table=>'map_view'

  def wms_updated_at

    if layer_type == "wms"
      wms_time_url = "http://mapserver.eol.ucar.edu/ops/#{wms_layer}.txt"
      wms_time_service = URI.parse wms_time_url
      http = Net::HTTP.new wms_time_service.host
      http.open_timeout = 2 # seconds
      http.read_timeout = 2 # seconds
      begin
        wms_time_response = http.request_get wms_time_service.request_uri
        return wms_time_response.body

      rescue Exception => e
        logger.warn "Error requesting resource: #{wms_time_url}"
        return nil
      end

    end
  end

end

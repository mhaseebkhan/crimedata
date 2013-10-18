class Crime < ActiveRecord::Base

  def self.json_converion_for_maps crime_type_array_main, crime_data, type
    crime_type_array = []
    crime = {}
    crime_type_array_main.each_with_index do |crime_type, index|
      crime_type_array[index] = crime_data.select{|key, val| key[type] == crime_type}
      temp_arr = '['
      crime_type_array[index].each_with_index do |crime, ind|
        temp_arr = temp_arr + '{'
        description = '"description":"'
        latitude = ""
        longitude = ""
        title = ""
        crime.each do |key, val|
          if key == 'latitude'
            latitude =  '"lat":' + "'#{val}'" + ','
          elsif key == 'longitude'
            longitude = '"lng":' + "'#{val}'" + ','
          elsif key == 'case_number'
            title = '"title":' + "'#{val}'" + ','
          elsif key != 'location'
            description = description + "#{key}" + ':' + " #{val} --- "
          end
        end
        temp_arr = temp_arr + latitude + longitude + title + description + '"},'
      end
      crime_type_array[index] = temp_arr + ']'
      crime[crime_type] = temp_arr + ']'
    end
    [crime, crime_type_array]
  end

end

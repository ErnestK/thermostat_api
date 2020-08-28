# frozen_string_literal: true

module WithRedisNaming
  def dict_collection_name
    'hash:stats:disctionary'
  end

  def ids_readings_collection_name
    'hash:readings:ids:dictionary'
  end

  def cache_readings_collection_name
    'hash:cache:readings'
  end
end

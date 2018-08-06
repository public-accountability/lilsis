# frozen_string_literal: true

# This stores sets of NetworkMap ids
# in the Rails Cache (redis), so they can
# be easily retrieved to display on an entity's
# profile page.
#
#
class EntityNetworkMapCollection
  attr_accessor :maps
  extend Forwardable
  def_delegators :@maps, :each, :map, :size, :sort

  def initialize(entity_or_id)
    @entity_id = Entity.entity_id_for(entity_or_id)
    @cache_key = cache_key
    @maps = cache_exists? ? cache_read : Set.new
  end

  # methods #add and #remove do NOT persist the data
  # #save must be called afterwards.

  def add(network_map_id)
    @maps.add network_map_id
    self
  end

  def remove(network_map_id)
    @maps.delete network_map_id
    self
  end

  # deletes the set from cache
  def delete
    @maps.clear
    Rails.cache.delete(@cache_key)
    self
  end

  def save
    @maps.empty? ? delete : cache_write(@maps)
    self
  end

  ## class methods ##

  def self.remove_all(network_map_id)
  end

  private

  def cache_key
    "entity-#{@entity_id}/networkmaps"
  end

  def cache_exists?
    Rails.cache.exist?(@cache_key)
  end

  def cache_read
    Rails.cache.read(@cache_key)
  end

  def cache_write(value)
    Rails.cache.write(@cache_key, value)
  end
end

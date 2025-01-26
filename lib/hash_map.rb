# frozen_string_literal: true

class HashMap # rubocop:disable Style/Documentation
  attr_reader :load_factor, :capacity, :buckets

  def initialize
    @load_factor = 0.75
    @buckets = Array.new(16) { [] }
  end

  def set(key, value)
    check_load
    address = buckets[position(key)]
    if address.empty?
      address << key
      address << value
    else
      manage_collisions(key, value)
    end
  end

  def get(key)
    address = buckets[position(key)]
    key_position = key_index(key, address)

    return nil if key_position.nil?

    address[key_position + 1]
  end

  def has?(key)
    key_position = key_index(key, buckets[position(key)])

    return false if key_position.nil?

    true
  end

  def remove(key)
    address = buckets[position(key)]
    key_position = key_index(key, address)
    return nil if key_position.nil?

    address.delete_at(key_position)
    address.delete_at(key_position)
  end

  def length
    count = 0
    buckets.each do |item|
      count += item.length / 2 unless item.nil?
    end
    count
  end

  def clear
    @buckets = Array.new(16) { [] }
  end

  def keys
    result = []
    current_index = 0
    flatten_buckets = buckets.flatten
    while current_index <= flatten_buckets.length - 1
      result << flatten_buckets[current_index]
      current_index += 2
    end
    result
  end

  private

  def manage_collisions(key, value)
    address = buckets[position(key)]
    key_position = key_index(key, address)

    if key_position.nil?
      address << key
      address << value
    else
      address[key_position] = value
    end
  end

  def hash_code(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

  # gets the address(index) of the key in the hashmap
  def position(key)
    index = hash_code(key) % buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  def check_load
    empty_buckets = buckets.length - (load_factor * buckets.length).round
    update_buckets if buckets.count([]) <= empty_buckets
  end

  def update_buckets
    @buckets = buckets + Array.new(buckets.length) { [] }
  end

  def key_index(key, address)
    current_index = 0
    while current_index < address.length - 1
      return current_index if hash_code(key) == hash_code(address[current_index])

      current_index += 2
    end
    nil
  end
end

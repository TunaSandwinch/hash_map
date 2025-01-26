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
    return unless address.length == 2

    nil
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

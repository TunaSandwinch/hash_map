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

  private

  def manage_collisions(key, value) # rubocop:disable Metrics/MethodLength
    address = buckets[position(key)]
    current_index = 0
    while current_index < address.length - 1
      if  hash_code(key) == hash_code(address[current_index])
        address[current_index + 1] = value
        return
      end
      current_index += 2
    end
    address << key
    address << value
  end

  def hash_code(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

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
end

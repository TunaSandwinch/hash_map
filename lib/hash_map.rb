# frozen_string_literal: true

class HashMap # rubocop:disable Style/Documentation
  attr_reader :load_factor, :capacity, :buckets

  def initialize
    @load_factor = 0.8
    @buckets = Array.new(16, [])
  end

  private

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

  def check_load
    empty_buckets = buckets.length - (load_factor * buckets.length).round
    update_buckets if buckets.count([]) <= empty_buckets
  end

  def update_buckets
    @buckets = buckets + Array.new(buckets.length, [])
  end
  # TODO: make a method that will check if the value belongs to a key if there is more than 1 value inside an address
  #
end

class KeyedRelation
  def initialize(unkeyed_relation)
    @hash = unkeyed_relation.inject({}) do |result, record|
      result.update record.key => record
    end
  end

  def [](key)
    @hash[key]
  end

  def []=(key, record)
    @hash[key] = record
  end

  def each(&block)
    values.each &block
  end

  def key?(key)
    @hash.key? key
  end

  def values
    @hash.values
  end
end

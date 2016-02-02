class Kvdb
  def initialize(host, port)
    @@host = host
    @@port = port

    @@hashes = {}
  end

  def hset(hash, key, value)
    if not (@@hashes.include?(hash))
      @@hashes[hash] = {}
    end

    @@hashes[hash][key] = value.to_s
  end

  def hget(hash, key)
    return @@hashes[hash][key]
  end

  def hgetall(hash)
    return @@hashes[hash]
  end

end

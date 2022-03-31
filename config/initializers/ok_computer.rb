# frozen_string_literal: true

OkComputer::Registry.register 'cache_check', OkComputer::CacheCheck.new

OkComputer.mount_at = 'health'

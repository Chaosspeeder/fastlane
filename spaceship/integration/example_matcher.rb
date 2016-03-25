require 'diff_matcher'
require 'multi_json'

RSpec::Matchers.define :match_apple_ten_char_id do |example_path|
  match do |actual|
    @opts = { color_enabled: RSpec::configuration.color_enabled? }
    @difference = DiffMatcher::Difference.new(/^[a-zA-Z0-9]{10}$/, actual, @opts)
    @difference.matching?
  end

  failure_message do |model|
    @difference.to_s
  end
end

RSpec::Matchers.define :match_a_udid do |example_path|
  match do |actual|
    @opts = { color_enabled: RSpec::configuration.color_enabled? }
    @difference = DiffMatcher::Difference.new(/^[a-fA-F0-9]{40}$/, actual, @opts)
    @difference.matching?
  end

  failure_message do |model|
    @difference.to_s
  end
end

EXAMPLE_MATCHERS = {
  'number' => lambda {|arg| arg.is_a? Fixnum},
  'anything-or-empty' => lambda {|arg| /.*/ || (arg == nil)},
  'apple-app-id' => /^[A-Z0-9]{10}$/,
  'boolean' => lambda {|arg| arg.is_a?(TrueClass) || arg.is_a?(FalseClass)},
  'email' => /^[^@]+@\w+.\w+$/,
  'text' => /.+/,
  'anything' => /.*/,
  'url' => /http[s]?:\/\/.*/,
}.freeze

RSpec::Matchers.define :match_example do |example_path|
  def expectify(arg)
    case arg
    when /^\$(.*)/ then EXAMPLE_MATCHERS[$1]
    when /^\/(.*)\/$/ then Regexp.new($1)
    when Array then arg.map {|el| expectify(el)}
    when Hash then {}.tap {|h| arg.each {|k, v| h[k] = expectify(v) } }
    else arg
    end
  end

  # JSON stuff is all strings, but params from Ruby can contain symbols
  def deep_stringify(hsh)
    hsh.each do |key, value|
      if value.is_a?(Hash)
        deep_stringify(value)
      elsif value.is_a?(Symbol)
        hsh.delete[key]
        hsh[key.to_s] = value.to_s
      end
    end

    hsh
  end

  match do |actual|
    expected = File.read(File.join(File.expand_path("../../", __FILE__), '/', example_path))

    parsed_hash = MultiJson.load(expected)
    # We have a special section called "path_params" so it's clear what params are passed
    # in the URL path (ids and such) rather than as query params.
    if parsed_hash['$path_params']
      parsed_hash.merge!(parsed_hash.delete('$path_params'))
    end

    actual_hash = if response.is_a?(Hash)
      deep_stringify(response)
    else
      MultiJson.load(response.body)
    end

    expected_hash = expectify(parsed_hash)

    @opts = {:color_enabled=>RSpec::configuration.color_enabled?}
    @difference = DiffMatcher::Difference.new(expected_hash, actual_hash, @opts)
    @difference.matching?
  end

  failure_message do |model|
    @difference.to_s
  end
end

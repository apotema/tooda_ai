module McpLogger
  def self.log(payload, tag: nil)
  return unless Rails.env.development? || Rails.env.test?

    path = Rails.root.join('mpc-log.txt')
    line = "[#{Time.now.utc.iso8601}]"
    line += " [#{tag}]" if tag
    text =
      case payload
      when String then payload
      when Hash, Array then payload.inspect
      else payload.to_s
      end
    File.open(path, 'a') { |f| f.puts(line + ' ' + text) }
  rescue => e
    Rails.logger.error("McpLogger error: #{e.class}: #{e.message}")
  end
end

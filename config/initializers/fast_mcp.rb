require 'fast_mcp'

FastMcp.mount_in_rails(
  Rails.application,
  name: Rails.application.class.module_parent_name.underscore.dasherize,
  version: '1.0.0',
  path_prefix: '/mcp',
  messages_route: 'messages',
  sse_route: 'sse',
  allowed_origins: ['localhost', '127.0.0.1', /\A\[::1\]\z/],
  localhost_only: true,
  allowed_ips: ['127.0.0.1', '::1']
) do |server|
  Rails.application.config.after_initialize do
    # Ensure tool/resource classes are loaded so descendants are discovered (esp. in development)
    Dir[Rails.root.join('app/tools/**/*.rb')].sort.each { |f| require_dependency f }
    Dir[Rails.root.join('app/resources/**/*.rb')].sort.each { |f| require_dependency f }

    tools = ApplicationTool.descendants
    resources = ApplicationResource.descendants

    server.register_tools(*tools)
    server.register_resources(*resources)

    # Store a simple registry snapshot for debugging
    Rails.application.config.x.mcp = {
      tool_classes: tools.map(&:name),
      resource_classes: resources.map(&:name),
      resource_uris: resources.map { |r| r.respond_to?(:uri) ? r.uri : nil }.compact
    }
  end
end

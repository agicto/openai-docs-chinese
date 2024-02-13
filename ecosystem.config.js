module.exports = {
  apps: [
    {
      name: `openaicto`,
      script: './server.js',
      autorestart: true,
      watch: true,
      exec_mode: 'cluster',
      max_memory_restart: '1G',
      instances: `1`,
      node_args: '--max-http-header-size=2400',
    },
  ],
}

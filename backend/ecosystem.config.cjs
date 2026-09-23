module.exports = {
  apps: [
    {
      name: 'gym',
      cwd: __dirname,
      script: 'node_modules/next/dist/bin/next',
      args: 'start --port 3000',
      interpreter: 'node',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        NODE_OPTIONS: '--no-deprecation',
      },
    },
  ],
}

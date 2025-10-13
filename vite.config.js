import { defineConfig } from 'vite'
import { coffee } from 'vite-plugin-coffee3'
import { analyzer } from 'vite-bundle-analyzer'
import { resolve } from 'path' // Import 'resolve' from 'path'

import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [
    // externalizeDeps(),
    analyzer({openAnalyzer: false, analyzerMode: 'static'}),
    {...coffee(), enforce: 'pre'},
    react({ include: /\.(coffee|js|jsx|ts|tsx)$/ })
  ],
  esbuild: {
    loader: 'jsx',
    include: /.*\.(jsx?|coffee)$/,
  },
  server: {
    port: 1234,
    allowedHosts: true
  },
  resolve: {
    extensions: ['.coffee', '.css', '.sass', '.vue', '.js', '.ts', '.jsx', '.tsx', '.json'],
    alias: {
      '/': resolve(__dirname, '.'), // Maps '@' to the root directory
      // You can add more aliases as needed, e.g., '@components': resolve(__dirname, './src/components')
    },
  },
})

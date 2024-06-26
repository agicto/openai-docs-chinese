const express = require('express')
const next = require('next')
const port = parseInt(process.env.PORT, 10) || 7011
console.log('process.env.NODE_ENV', process.env.NODE_ENV)
console.log('process.env.INIT_ENV', process.env.INIT_ENV)
const dev = process.env.NODE_ENV !== 'production'
const app = next({ dev })
const handle = app.getRequestHandler()

app.prepare().then(() => {
  const server = express()

  server.all('*', (req, res) => {
    return handle(req, res)
  })

  server.listen(port, err => {
    if (err) throw err
    console.log(`> Ready on http://localhost:${port}`)
  })
})

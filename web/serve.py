#!/usr/bin/env python3
"""Local HTTP server for web/ (run from repo root or web/)."""
import http.server
import os

if os.path.isfile(os.path.join(os.path.dirname(__file__), 'run.html')):
    ROOT = os.path.dirname(os.path.abspath(__file__))
else:
    ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'web')
os.chdir(ROOT)


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        if self.path.endswith(('.js', '.wasm', '.html', '.data')):
            self.send_header('Cache-Control', 'no-store')
        super().end_headers()


if __name__ == '__main__':
    port = int(os.environ.get('RR_PORT', '8767'))
    print('Serving:', ROOT)
    print('Open: http://127.0.0.1:%d/run.html' % port)
    http.server.ThreadingHTTPServer(('127.0.0.1', port), Handler).serve_forever()

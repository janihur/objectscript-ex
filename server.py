#!/usr/bin/env python3
"""
License: MIT License
Copyright (c) 2023 Miel Donkers

https://gist.github.com/mdonkers/63e115cc0c79b4f6b8b3a6b797e485c7

Very simple HTTP server in python for logging requests
Usage::
    ./server.py [<port>]
"""
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer

import logging
import os
import re

def get_count(path):
    query_string = path.split('?')
    if len(query_string) == 2:
        match = re.compile(r'\d+').search(query_string[1])
        if match:
            return int(match.group())

    return 1

class S(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain; charset=UTF-8')
        self.end_headers()

    def do_GET(self):
        logging.info("--- new GET request ----------------------------------------")
        logging.info("GET request,\nPath: %s\nHeaders:\n%s\n", str(self.path), str(self.headers))

        if self.path.startswith('/export'):
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain; charset=UTF-8')
            self.end_headers()

            count = get_count(self.path)
            logging.info("Export count: %d", count)

            with open(os.path.expanduser('~/pg7000.txt'), 'r') as f:
                for i in range(count):
                    self.wfile.write("*** Export count: {}\n\n".format(i+1).encode('utf-8'))
                    self.wfile.write(f.read().encode('utf-8'))
                    f.seek(0)
        else:
            self._set_response()
            self.wfile.write("GET request for {}".format(self.path).encode('utf-8'))

    def do_POST(self):
        logging.info("--- new POST request ----------------------------------------")
        content_length = int(self.headers['Content-Length']) # <--- Gets the size of data

        if self.path.startswith('/import'):
            filename = '/tmp/imported-{}.txt'.format(datetime.now().strftime('%Y%m%dT%H%M%S'))
            with open(filename, 'w') as f:
                f.write(self.rfile.read(content_length).decode('utf-8'))
            logging.info("POST request,\nPath: %s\nHeaders:\n%s\n",
                str(self.path), str(self.headers))

            self._set_response()
            self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))
        else:
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                str(self.path), str(self.headers), post_data.decode('utf-8'))

            self._set_response()
            self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))

def run(server_class=HTTPServer, handler_class=S, port=8080):
    logging.basicConfig(level=logging.INFO)
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    logging.info('Starting httpd...\n')
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info('Stopping httpd...\n')

if __name__ == '__main__':
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()

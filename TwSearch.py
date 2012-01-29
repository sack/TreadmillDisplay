#!/usr/bin/python2.6
import json,urllib
from StringIO import StringIO

SEARCH_BASE = 'http://search.twitter.com/search.json'

def search(query, **kwargs):
    kwargs.update({
        'q': query
        })
    url = SEARCH_BASE + '?' + urllib.urlencode(kwargs)
    return json.load(urllib.urlopen(url))

#!/usr/bin/python
import os,sys
os.environ['DJANGO_SETTINGS_MODULE'] = 'desktop.core.settings'
 
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()


import logging
import sys
import traceback
from django.http import HttpResponseRedirect

from desktop.core.lib.django_util import render

LOG = logging.getLogger(__name__)

def home(request):
    return HttpResponseRedirect("/ansible/")

def log_view(request):
    l = logging.getLogger()
    return render('logs.html', request, dict(log=["No logs found!"]))

def serve_404_error(request, *args, **kwargs):
    """Registered handler for 404. We just return a simple error"""
    return render("404.html", request, dict(uri=request.build_absolute_uri()))

def serve_500_error(request, *args, **kwargs):
    """Registered handler for 500. We use the debug view to make debugging easier."""
    exc_info = sys.exc_info()
    return render("500.html", request, {'traceback': traceback.extract_tb(exc_info[2])})

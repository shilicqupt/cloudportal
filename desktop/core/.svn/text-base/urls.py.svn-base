from django.conf.urls import patterns, include, url


import desktop.apps.ansible.urls
import desktop.apps.account.urls

from django.contrib import admin
admin.autodiscover()

handler404 = 'desktop.core.views.serve_404_error'
handler500 = 'desktop.core.views.serve_500_error'

urlpatterns = patterns('',
     url(r'^$', 'desktop.core.views.home', name='home'),

    (r'^accounts/login/$', 'desktop.core.auth.views.dt_login'),
    (r'^accounts/logout/$', 'desktop.core.auth.views.dt_logout', {'next_page': '/'}),
    (r'^logs$','desktop.core.views.log_view'),

    # Uncomment the admin/doc line below to enable admin documentation:
#    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
    url(r'^ansible/', include(desktop.apps.ansible.urls)),
    url(r'^account/', include(desktop.apps.account.urls)),




)

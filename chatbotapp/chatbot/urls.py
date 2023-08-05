from . import views
from django.urls import path

urlpatterns = [
    path('register',views.register,name='register'),
    path('home',views.home,name='home'),
    path('history',views.history,name='history'),
    path('login',views.login_func,name='login'),
    path('logout',views.logout_func,name='logout')
]

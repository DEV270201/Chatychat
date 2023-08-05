from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model

class RegistrationForm(UserCreationForm):
    first_name = forms.CharField(max_length=50,required=True)
    last_name = forms.CharField(max_length=50,required=True)
    email = forms.EmailField(required=True)

    class Meta:
        model = get_user_model()
        fields = ['first_name','last_name','username','email','password1','password2']

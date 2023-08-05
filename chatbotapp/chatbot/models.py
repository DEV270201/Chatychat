from django.contrib.auth.models import AbstractUser
from django.db import models
from django.contrib.auth import get_user_model
from django.conf import settings

class MyUser(AbstractUser):
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.username

class QnA(models.Model):
    # User = get_user_model()
    user = models.ForeignKey(MyUser,on_delete=models.CASCADE)
    question = models.CharField(max_length=300)
    answer = models.TextField()

    def __str__(self):
        return f"{self.user.username} - {self.question}"

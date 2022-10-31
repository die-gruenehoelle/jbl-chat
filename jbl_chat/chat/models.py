from django.contrib.auth.models import User
from django.db import models


class Message(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='message_from')
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='message_to')
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

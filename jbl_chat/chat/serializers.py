from django.contrib.auth.models import User
from rest_framework import serializers

from .models import Message


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'date_joined']


class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = ['author', 'recipient', 'message', 'created_at']

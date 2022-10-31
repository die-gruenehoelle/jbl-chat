from django.db.models import Q
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response

from .models import Message
from .serializers import UserSerializer, MessageSerializer


class UserViewSet(ViewSet):

    def list(self, request):
        queryset = User.objects.all()
        serializer = UserSerializer(queryset, many=True)
        return Response(serializer.data)


class MessageViewSet(ViewSet):

    def retrieve(self, request, pk):
        if request.user.username == pk:
            return Response({'status': 'error', 'message': 'recipient missing'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            recipient = User.objects.get(username=pk)
        except User.DoesNotExist:
            return Response({'status': 'error', 'message': 'recipient unknown'}, status=status.HTTP_404_NOT_FOUND)

        queryset = Message.objects.filter(
            Q(author=request.user, recipient=recipient) | Q(author=recipient, recipient=request.user)
        )
        serializer = MessageSerializer(queryset, many=True)
        return Response(serializer.data)

    def create(self, request):
        if 'recipient' not in request.data or request.user.username == request.data['recipient']:
            return Response({'status': 'error', 'message': 'recipient missing'}, status=status.HTTP_400_BAD_REQUEST)

        if 'message' not in request.data:
            return Response({'status': 'error', 'message': 'message missing'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            recipient = User.objects.get(username=request.data['recipient'])
        except User.DoesNotExist:
            return Response({'status': 'error', 'message': 'recipient unknown'}, status=status.HTTP_404_NOT_FOUND)

        message = Message.objects.create(
            author=request.user,
            recipient=recipient,
            message=request.data['message'],
        )
        message.save()

        return Response({'status': 'ok'})

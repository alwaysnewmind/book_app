import 'package:book_app/features/community/models/message_model.dart';

final List<Message> dummyMessages = [
  Message(
    id: 'm1',
    senderId: 'u1',
    content: 'Hey! Have you read Atomic Habits?',
    type: MessageType.text,
    timestamp:
        DateTime.now().subtract(const Duration(minutes: 20)),
    isSeen: true,
  ),
  Message(
    id: 'm2',
    senderId: 'u2',
    content: 'Yes! It completely changed my routine 🔥',
    type: MessageType.text,
    timestamp:
        DateTime.now().subtract(const Duration(minutes: 18)),
    isSeen: true,
  ),
  Message(
    id: 'm3',
    senderId: 'u1',
    content:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794',
    type: MessageType.image,
    timestamp:
        DateTime.now().subtract(const Duration(minutes: 15)),
    isSeen: true,
  ),
  Message(
    id: 'm4',
    senderId: 'u2',
    content: 'Nice shelf setup 😍',
    type: MessageType.text,
    timestamp:
        DateTime.now().subtract(const Duration(minutes: 12)),
    isSeen: false,
  ),
  Message(
    id: 'm5',
    senderId: 'u1',
    content:
        'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f',
    type: MessageType.image,
    timestamp:
        DateTime.now().subtract(const Duration(minutes: 10)),
    isSeen: false,
  ),
];
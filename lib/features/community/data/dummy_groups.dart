import 'package:book_app/features/community/models/group_model.dart' show GroupModel;
 

final List<GroupModel> dummyGroups = [
  GroupModel(
    id: 'g1',
    name: 'Book Lovers Club',
    description: 'A place for passionate readers 📚',
    imageUrl:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794',
    membersCount: 120,
    isPrivate: false,
    lastMessage: 'Next book discussion on Sunday!',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
  ),
  GroupModel(
    id: 'g2',
    name: 'Fantasy Readers',
    description: 'Discuss fantasy novels and worlds ✨',
    imageUrl:
        'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f',
    membersCount: 85,
    isPrivate: false,
    lastMessage: 'Have you read Fourth Wing?',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  GroupModel(
    id: 'g3',
    name: 'Writers Circle',
    description: 'Share your writing & get feedback ✍️',
    imageUrl:
        'https://images.unsplash.com/photo-1455390582262-044cdead277a',
    membersCount: 42,
    isPrivate: true,
    lastMessage: 'Weekly writing challenge posted!',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  GroupModel(
    id: 'g4',
    name: 'Startup Readers',
    description: 'Business & self-growth book discussions 🚀',
    imageUrl:
        'https://images.unsplash.com/photo-1492724441997-5dc865305da7',
    membersCount: 64,
    isPrivate: false,
    lastMessage: 'Atomic Habits review session today.',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
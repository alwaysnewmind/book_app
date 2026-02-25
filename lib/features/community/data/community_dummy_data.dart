import '../models/group_model.dart';
import '../models/user_model.dart';

class CommunityDummyData {
  static final List<GroupModel> groups = [
    GroupModel(
      id: 'g1',
      name: 'Book Lovers',
      description: 'Daily reading discussion and recommendations.',
      imageUrl: '',
      membersCount: 12,
      isPrivate: false,
      lastMessage: 'Next week we start a new novel!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    GroupModel(
      id: 'g2',
      name: 'Fantasy Readers',
      description: 'Everything fantasy, from classics to modern epics.',
      imageUrl: '',
      membersCount: 8,
      isPrivate: false,
      lastMessage: 'Chapter 5 discussion tonight 🔥',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    GroupModel(
      id: 'g3',
      name: 'Writers Hub',
      description: 'Share drafts and get feedback.',
      imageUrl: '',
      membersCount: 15,
      isPrivate: true,
      lastMessage: 'Share your drafts here',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  static final List<UserModel> friends = [
    UserModel(
      id: 'u1',
      name: 'Aman Verma',
      email: 'aman@example.com',
      profileImage: '',
      isOnline: true,
      lastSeen: DateTime.now(),
      bio: 'Sci-fi lover',
    ),
    UserModel(
      id: 'u2',
      name: 'Riya Patel',
      email: 'riya@example.com',
      profileImage: '',
      isOnline: true,
      lastSeen: DateTime.now(),
      bio: 'Fantasy enthusiast',
    ),
    UserModel(
      id: 'u3',
      name: 'Karan Shah',
      email: 'karan@example.com',
      profileImage: '',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 45)),
      bio: 'Poetry reader',
    ),
    UserModel(
      id: 'u4',
      name: 'Sneha Mehta',
      email: 'sneha@example.com',
      profileImage: '',
      isOnline: true,
      lastSeen: DateTime.now(),
      bio: 'Self-help addict',
    ),
    UserModel(
      id: 'u5',
      name: 'Dev Joshi',
      email: 'dev@example.com',
      profileImage: '',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      bio: 'History buff',
    ),
  ];
}

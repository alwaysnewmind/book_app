import 'package:book_app/features/community/models/user_model.dart' show UserModel;


final List<UserModel> dummyUsers = [
  UserModel(
    id: 'u1',
    name: 'Jay Patel',
    email: 'jay@example.com',
    profileImage:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
    isOnline: true,
    lastSeen: DateTime.now(),
    bio: 'Book enthusiast 📚 | Self-growth lover',
  ),
  UserModel(
    id: 'u2',
    name: 'Aarav Sharma',
    email: 'aarav@example.com',
    profileImage:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(minutes: 25)),
    bio: 'Fantasy novels & world building ✨',
  ),
  UserModel(
    id: 'u3',
    name: 'Riya Mehta',
    email: 'riya@example.com',
    profileImage:
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
    isOnline: true,
    lastSeen: DateTime.now(),
    bio: 'Writer ✍️ | Coffee + Books',
  ),
  UserModel(
    id: 'u4',
    name: 'Kabir Singh',
    email: 'kabir@example.com',
    profileImage:
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
    isOnline: false,
    lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
    bio: 'Startup & productivity reader 🚀',
  ),
];
class AppUser {
  final String id;
  final String name;
  final String email;
  final String profilePic;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.profilePic = "https://ui-avatars.com/api/?name=User",
  });
}
class UserModel {
  final String userId;
  final String userName;
  final String email;
  final String password;
  final String userProfile;

  UserModel(
      {this.userId,
      this.userName,
      this.userProfile,
      this.email,
      this.password});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfile': userProfile,
      'email': email,
      'password': password,
    };
  }
}

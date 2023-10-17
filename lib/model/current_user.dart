class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  factory CurrentUser() => _instance;

  CurrentUser._internal();

  String? userId; // To store the user's document ID
  String? userType; // To store the user's type
}

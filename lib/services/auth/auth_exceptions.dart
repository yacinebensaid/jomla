// we have to handel the exceptions here better than the direct interaction with the ui
// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exception, all exceptions
class GenericAuthException implements Exception {}

// user not logged in exceptions
class UserNotLoggedInAuthException implements Exception {}

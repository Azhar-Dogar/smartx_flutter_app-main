class SnackbarMessage {
  final String message;
  final bool isForSuccess;
  final bool isLongDuration;

  const SnackbarMessage({required this.message, required this.isForSuccess, required this.isLongDuration});

  SnackbarMessage.success({required String message, bool isLongDuration = false})
      : this(message: message, isForSuccess: true, isLongDuration: isLongDuration);

  SnackbarMessage.error({required String message, bool isLongDuration = false})
      : this(message: message, isForSuccess: false, isLongDuration: isLongDuration);

  const SnackbarMessage.empty() : this(message: '', isForSuccess: false, isLongDuration: false);

  @override
  String toString() {
    return 'SnackbarMessage{message: $message, isForSuccess: $isForSuccess, isLongDuration: $isLongDuration}';
  }
}

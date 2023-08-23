


class MaterialDialogContent {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;

  MaterialDialogContent(
      {required this.title,
        required this.message,
        this.positiveText = "Try Agian",
        this.negativeText = "Cancel"});

  MaterialDialogContent.networkError()
      : this(
      title: "LIMITED NETWORK CONNECTION",
      message: "uhh ho looks like something went wrong,please check your internet connection");

  @override
  String toString() {
    return 'MaterialDialogContent{title: $title, message: $message, positiveText: $positiveText, negativeText: $negativeText}';
  }
}
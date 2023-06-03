extension StringExtension on String {
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }

  String capitalizeFirstLetter() {
    if (trim().isEmpty) {
      return '';
    }
    return "${substring(0, 1).toUpperCase()}${substring(1)}";
  }

  String lowercaseFirstLetter() {
    if (trim().isEmpty) {
      return '';
    }
    return "${substring(0, 1).toLowerCase()}${substring(1)}";
  }
}

/// https://stackoverflow.com/a/61867272
extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }
}

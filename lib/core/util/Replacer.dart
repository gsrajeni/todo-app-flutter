extension Extension on Object {
  int ifNullThenZero() {
    if (this == null) {
      return 0;
    } else
      return this;
  }

  bool isNullOrEmpty() => this == null || this == '';

  bool isNullEmptyOrFalse() => this == null || this == '' || !this;

  bool isNullEmptyZeroOrFalse() =>
      this == null || this == '' || !this || this == 0;
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String getShortName() {
    String finalWord = "";
    this.split(" ").forEach((element) {
      finalWord += element[0];
    });
    return finalWord;
  }
}

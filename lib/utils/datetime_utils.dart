extension DateTimeUtils on DateTime {
  String toFormattedString() {
    return '${_twoDigits(this.day)}/${_twoDigits(this.month)}/${this.year}';
  }

  String _twoDigits(int d) => d > 9 ? '$d' : '0$d';
}

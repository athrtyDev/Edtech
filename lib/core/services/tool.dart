class Tool {
  static bool isNullOrZero(double d) {
    if (d == null || d == 0)
        return true;
      else
        return false;
  }

  static String convertDoubleToString(double d) {
    return d.toStringAsFixed(d.truncateToDouble() == d ? 0 : 2);
  }
}
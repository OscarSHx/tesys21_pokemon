extension StringExtensions on String {
  //==========================================================
  /// EXTENSION DE STRING PARA CAPITALIZAR
  //==========================================================
  String get capitalizeString {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

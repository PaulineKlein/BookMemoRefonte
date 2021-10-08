extension StringExtension on String {

   String get removeAccents {
    String src = this;
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      src = src.replaceAll(withDia[i], withoutDia[i]);
    }
    return src;
  }

   String get removeCsvDelimiter {
     return this.replaceAll(";", ",");
   }
}
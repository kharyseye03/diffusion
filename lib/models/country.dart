class Country {
  final String name;
  final String flag;
  final String dialCode;
  const Country(this.name, this.flag, this.dialCode);
}

const List<Country> kCountries = [
  Country('Sénégal', '🇸🇳', '+221'),
  Country('Côte d\'Ivoire', '🇨🇮', '+225'),
  Country('Mali', '🇲🇱', '+223'),
  Country('Cameroun', '🇨🇲', '+237'),
  Country('France', '🇫🇷', '+33'),
];

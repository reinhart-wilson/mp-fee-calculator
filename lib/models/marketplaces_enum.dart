enum Marketplaces {
  tokopedia('Tokopedia', 'assets/data/tokopedia.json'),
  shopee('Shopee', 'assets/data/shopee.json');

  final String displayName;
  final String dataPath;

  const Marketplaces(this.displayName, this.dataPath);

  static Marketplaces fromString(String? str) {
    switch ((str ?? '').toLowerCase()) {
      case ('shopee'):
        return Marketplaces.shopee;
      default:
        return Marketplaces.tokopedia;
    }
  }
}

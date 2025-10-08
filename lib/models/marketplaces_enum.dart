enum Marketplaces {
  tokopedia('Tokopedia', 'assets/data/tokopedia.json'),;
  // shopee('Shopee', 'assets/data/shopee.json');

  final String displayName;
  final String dataPath;

  const Marketplaces(this.displayName, this.dataPath);
}

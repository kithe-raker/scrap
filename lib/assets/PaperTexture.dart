class PaperTexture {
  static const List<String> _textures = ['paperscrap.svg', 'yellowpaper.svg'];
  static const Map<String, int> _point = {
    'paperscrap.svg': 0,
    'yellowpaper.svg': 100,
  };

  Map<String, int> get point => _point;
  List<String> get textures => _textures;
}

final texture = PaperTexture();

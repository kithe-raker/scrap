class PaperTexture {
  static const Map<int, String> _textures = {
    0: 'paperscrap.svg',
    1: 'schoolpaper.svg',
    2: 'yellowpaper.svg',
    3: 'rainbowpaper.svg'
  };

  static const Map<String, int> _texturesIndex = {
    'paperscrap.svg': 0,
    'schoolpaper.svg': 1,
    'yellowpaper.svg': 2,
    'rainbowpaper.svg': 3
  };

  static const List<String> _texturesList = [
    'paperscrap.svg',
    'schoolpaper.svg',
    'rainbowpaper.svg',
    'yellowpaper.svg',
  ];
  static const Map<String, int> _point = {
    'paperscrap.svg': 0,
    'schoolpaper.svg': 0,
    'rainbowpaper.svg': 0,
    'yellowpaper.svg': 100,
  };

  Map<String, int> get point => _point;
  Map<int, String> get textures => _textures;
  Map<String, int> get texturesIndex => _texturesIndex;
  List<String> get texturesList => _texturesList;
}

final texture = PaperTexture();

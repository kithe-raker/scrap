class PaperTexture {
  static const List<String> _textures = ['paperscrap.jpg', 'paperboard.jpg'];
  static const Map<String, int> _point = {
    'paperscrap.jpg': 0,
    'paperboard.jpg': 100
  };

  Map<String, int> get point => _point;
  List<String> get textures => _textures;
}

final texture = PaperTexture();

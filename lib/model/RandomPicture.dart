class RandomPicture {
  String id, author, url, download_url;
  int width, height;

  RandomPicture(this.id, this.author, this.url, this.width, this.height, this.download_url);


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'author': author,
      'width': width,
      'height': height,
      'url': url,
      'download_url': download_url,
    };
    return map;
  }

  RandomPicture.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    author = map['author'];
    width = map['width'];
    height = map['height'];
    url = map['url'];
    download_url = map['download_url'];
  }
}

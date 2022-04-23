class NewsModel{
String _author;
String _title;
String _description;
String _url;
String _urlToImage;
String _publishedAt;
String _content;

NewsModel(this._author, this._title, this._description, this._url,
      this._urlToImage, this._publishedAt, this._content);

factory NewsModel.fromMap(Map<String,dynamic> data){
  return(NewsModel(
      data['author'] == null ? "" : data['author'],
      data['title'] == null ? "" : data['title'],
      data['description'] == null ? "" : data['description'],
      data['url'] == null ? "" : data['url'],
      data['urlToImage'] == null ? "" : data['urlToImage'],
      data['publishedAt'] == null ? "" : data['publishedAt'],
      data['content'] == null ? "" : data['content'],
  ));
}

Map<String, dynamic> toMap()=>{
  "author": author,
  "title": title,
  "description": description,
  "url": url,
  "urlToImage": urlToImage,
  "publishedAt": publishedAt,
  "content": content
};

String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get publishedAt => _publishedAt;

  set publishedAt(String value) {
    _publishedAt = value;
  }

  String get urlToImage => _urlToImage;

  set urlToImage(String value) {
    _urlToImage = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get author => _author;

  set author(String value) {
    _author = value;
  }
}
class Password {
  final int id;
  final String label;
  final String login;
  final String comment;
  final String value;
  final String url;

  Password({this.id, this.label, this.login, this.value, this.comment, this.url});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'login': login,
      'comment': comment,
      'value': value,
      'url': url,
    };
  }
}
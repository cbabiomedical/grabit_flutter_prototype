class UserModel {
  final String id;

  UserModel(this.id);

  String get friendlyId {
    final suffix = id.length >= 6 ? id.substring(id.length - 6) : id;
    return 'GRB-${suffix.toUpperCase()}';
  }
}

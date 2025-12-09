class UserModel {
  final String id;

  UserModel(this.id);

  String get friendlyId {
    final suffix = id.substring(id.length - 6).toUpperCase();
    return 'GRB-$suffix';
  }
}

class SinhVien {
  int id;
  String name;

  SinhVien(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    return map;
  }

  SinhVien.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}

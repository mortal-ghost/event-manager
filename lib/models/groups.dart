import 'package:flutter/material.dart';

class Group {
  late final String id;
  late final String title;
  late final Color color;
  late final IconData? icon;

  Group(
      {required this.id, required this.title, required this.color, this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'color': color.value,
    };
  }

  Group addId(String id) {
    return Group(id: id, title: title, color: color, icon: icon);
  }

  factory Group.fromMap(Map<String, dynamic> data) {
    return Group(
        id: data['id'],
        title: data['title'],
        color: Color(data['color']),
        icon: IconData(data['icon']));
  }
}

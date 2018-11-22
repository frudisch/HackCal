import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/user.dart';

class UserService {
  final String USER_URL = 'http://localhost:5000/user';

  Future<List<User>> getUser() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    return [
      User(uuid: 'uuid1', name: 'User1'),
      User(uuid: 'uuid2', name: 'User2'),
      User(uuid: 'uuid3', name: 'User3'),
      User(uuid: 'uuid4', name: 'User4'),
      User(uuid: 'uuid5', name: 'User5'),
      User(uuid: 'uuid6', name: 'User6')
    ];

    final String url = USER_URL;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body).map((i) => User.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load: GET ${url}');
    }
  }
}

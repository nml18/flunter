import 'dart:convert';
import 'dart:math';
import 'package:postgres/postgres.dart';

class Database {
  factory Database() => _instance;
  Database._internal();
  
  static final Database _instance = Database._internal();

  Future<Connection> getConnection() async {
    return Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'flunter_db',
        username: 'flunter_admin',
        password: 'penguin00',
      ),
    );
  }

  String generateSalt() {
    final random = Random.secure();
    return base64Url.encode(List.generate(16, (_) => random.nextInt(256)));
  }
}

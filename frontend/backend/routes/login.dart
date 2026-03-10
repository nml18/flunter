import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:flunter_backend/database.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method not allowed');
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final username = body['username']?.toString().trim();
    final password = body['password']?.toString();

    if (username == null || username.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'Username required'},
      );
    }

    if (password == null || password.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'Password required'},
      );
    }

    final conn = await Database().getConnection();

    try {
      // 1. Récupère l'utilisateur avec son sel
      final result = await conn.execute(
        Sql.named('SELECT salt, password_hash FROM users WHERE username = @username'),
        parameters: {'username': username},
      );

      if (result.isEmpty) {
        return Response.json(
          statusCode: 401,
          body: {'error': 'Invalid username or password'},
        );
      }

      // 2. Extrait le sel et le hash stocké
      final row = result.first;
      final storedSalt = row[0]! as String;
      final storedHash = row[1]! as String;

      // 3. Re-hache le mot de passe tapé avec le sel stocké
      final inputHash = sha256.convert(utf8.encode(password + storedSalt)).toString();

      // 4. Compare
      if (inputHash == storedHash) {
        return Response.json(
          body: {'message': 'Login successful'},
        );
      }
      else {
        return Response.json(
          statusCode: 401,
          body: {'error': 'Invalid username or password'},
        );
      }
    }
    finally {
      await conn.close();
    }
  }
  catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Internal server error'},
    );
  }
}

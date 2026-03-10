import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:flunter_backend/database.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  // Vérifie que c'est un POST
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method not allowed');
  }

  try {
    // Récupère les données
    final body = await context.request.json() as Map<String, dynamic>;
    final username = body['username']?.toString().trim();
    final password = body['password']?.toString();

    // Validation basique
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

    // Génère un sel unique et hache le mot de passe
    final salt = Database().generateSalt();
    final hash = sha256.convert(utf8.encode(password + salt)).toString();

    // Connexion DB
    final conn = await Database().getConnection();

    try {
      // Vérifie si l'utilisateur existe déjà
      final existing = await conn.execute(
        Sql.named('SELECT id FROM users WHERE username = @username'),
        parameters: {'username': username},
      );

      if (existing.isNotEmpty) {
        return Response.json(
          statusCode: 409,
          body: {'error': 'Username already exists'},
        );
      }

      // Crée l'utilisateur avec le sel
      await conn.execute(
        Sql.named('INSERT INTO users (username, salt, password_hash) VALUES (@username, @salt, @hash)'),
        parameters: {
          'username': username,
          'salt': salt,
          'hash': hash,
        },
      );

      return Response.json(
        statusCode: 201,
        body: {'message': 'User created successfully'},
      );
    } finally {
      await conn.close();
    }
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Internal server error'},
    );
  }
}

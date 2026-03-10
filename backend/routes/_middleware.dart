import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return (context) async {
    if (context.request.method == HttpMethod.options) {
      return Response(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      );
    }
    
    final response = await handler(context);
    
    return response.copyWith(
      headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
      },
    );
  };
}

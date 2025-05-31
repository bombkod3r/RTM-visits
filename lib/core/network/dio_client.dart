import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      headers: {
        'apikey': dotenv.env['SUPABASE_ANON_KEY'],
        'Authorization': 'Bearer ${dotenv.env['SUPABASE_ANON_KEY']}',
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioError e, handler) {
        return handler.next(e);
      },
    ));

    return dio;
  }
}
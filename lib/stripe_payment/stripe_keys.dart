import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiKeys {
  static String get secretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  static String get publishableKey => dotenv.env['PUBLISH_HASH_KEY'] ?? '';
  // static const String secretKey = "SECRET_KEY";
  //static const String publishableKey = "PUBLISH_HASH_KEY";
}

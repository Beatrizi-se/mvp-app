class ApiConfig {
  static const String baseUrl = 'http://localhost:3000;
  
  static Map<String, String> headers([String? token]) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token?.isNotEmpty ?? false) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}

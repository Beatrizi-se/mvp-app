class ApiConfig {
  static const String baseUrl = 'http://192.168.0.101:3000';
  
  static Map<String, String> headers([String? token]) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}

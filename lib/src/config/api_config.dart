class ApiConfig {
  // Se estiver usando o emulador Android, considere usar 'http://10.0.2.2:3000'
  // se o servidor estiver rodando na mesma máquina.
  // Caso o servidor esteja em outro dispositivo na rede, mantenha o IP abaixo:
  static const String baseUrl = 'http://192.168.100.33:3000';
  
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

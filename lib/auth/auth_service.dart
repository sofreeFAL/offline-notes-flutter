import 'dart:convert';
import 'dart:html' as html;

class AuthService {
  bool get isLoggedIn => _getAccessToken() != null;

  Future<void> login() async {
    const authUrl =
        'http://localhost:8080/realms/offline-notes/protocol/openid-connect/auth'
        '?client_id=offline-notes-web'
        '&response_type=token'
        '&scope=openid profile email'
        '&redirect_uri=http://localhost:3000/';

    html.window.location.href = authUrl;
  }

  Future<void> logout() async {
    html.window.localStorage.remove('access_token');
    html.window.location.href = 'http://localhost:3000/';
  }

  Future<void> handleRedirect() async {
    final hash = html.window.location.hash;

    if (hash.contains('access_token=')) {
      final fragment = hash.substring(1); // remove #
      final params = Uri.splitQueryString(fragment);
      final token = params['access_token'];

      if (token != null) {
        html.window.localStorage['access_token'] = token;
        html.window.history.replaceState(null, '', '/');
      }
    }
  }

  Future<Map<String, dynamic>> userInfo() async {
    final token = _getAccessToken();
    if (token == null) {
      throw Exception("Not logged in");
    }

    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid token");
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  String? _getAccessToken() {
    return html.window.localStorage['access_token'];
  }
}
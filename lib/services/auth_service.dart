import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _nomeUsuarioKey = 'auth_nome_usuario';
  static const String _emailKey = 'auth_email';
  static const String _senhaKey = 'auth_senha';
  static const String _logadoKey = 'auth_logado';

  static Future<bool> estaLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_logadoKey) ?? false;
  }

  static Future<String?> emailAtual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String> nomeUsuarioAtual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nomeUsuarioKey) ?? 'voce';
  }

  static Future<bool> temContaCriada() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) != null;
  }

  static Future<String?> criarConta({
    required String nomeUsuario,
    required String email,
    required String senha,
  }) async {
    final nomeNormalizado = nomeUsuario.trim();
    final emailNormalizado = email.trim().toLowerCase();

    if (nomeNormalizado.length < 2) {
      return 'Digite seu nome de usuario.';
    }

    if (!_emailValido(emailNormalizado)) {
      return 'Digite um email valido.';
    }

    if (senha.length < 6) {
      return 'A senha precisa ter pelo menos 6 caracteres.';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nomeUsuarioKey, nomeNormalizado);
    await prefs.setString(_emailKey, emailNormalizado);
    await prefs.setString(_senhaKey, senha);
    await prefs.setBool(_logadoKey, true);

    return null;
  }

  static Future<String?> entrar({
    required String email,
    required String senha,
  }) async {
    final emailNormalizado = email.trim().toLowerCase();
    final prefs = await SharedPreferences.getInstance();

    final emailSalvo = prefs.getString(_emailKey);
    final senhaSalva = prefs.getString(_senhaKey);

    if (emailSalvo == null || senhaSalva == null) {
      return 'Crie uma conta antes de entrar.';
    }

    if (emailNormalizado != emailSalvo || senha != senhaSalva) {
      return 'Email ou senha incorretos.';
    }

    await prefs.setBool(_logadoKey, true);
    return null;
  }

  static Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_logadoKey, false);
  }

  static bool _emailValido(String email) {
    return email.contains('@') && email.contains('.') && email.length >= 6;
  }
}

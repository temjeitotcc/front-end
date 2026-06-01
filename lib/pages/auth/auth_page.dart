import 'package:flutter/material.dart';
import '../../main.dart';
import '../../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeUsuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _criandoConta = true;
  bool _carregando = false;
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _nomeUsuarioController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    setState(() => _carregando = true);

    final erro = _criandoConta
        ? await AuthService.criarConta(
            nomeUsuario: _nomeUsuarioController.text,
            email: _emailController.text,
            senha: _senhaController.text,
          )
        : await AuthService.entrar(
            email: _emailController.text,
            senha: _senhaController.text,
          );

    if (!mounted) return;

    setState(() => _carregando = false);

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }

    final appState = MyApp.maybeOf(context);
    if (appState != null) {
      await appState.atualizarLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textoPrincipal =
        Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/icon3.png', height: 86),
                  const SizedBox(height: 18),
                  Text(
                    _criandoConta ? 'Criar conta' : 'Entrar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _criandoConta
                        ? 'Crie sua conta para começar sua jornada.'
                        : 'Entre para continuar de onde parou.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        if (_criandoConta) ...[
                          TextFormField(
                            controller: _nomeUsuarioController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nome de usuário',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                              border: OutlineInputBorder(),
                            ),
                            validator: (valor) {
                              if (!_criandoConta) return null;

                              final nome = valor?.trim() ?? '';
                              if (nome.length < 2) {
                                return 'Digite seu nome de usuário.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                        ],
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (valor) {
                            final email = valor?.trim() ?? '';
                            if (!email.contains('@') || !email.contains('.')) {
                              return 'Digite um email válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: _ocultarSenha,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _ocultarSenha
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() => _ocultarSenha = !_ocultarSenha);
                              },
                            ),
                          ),
                          validator: (valor) {
                            if ((valor ?? '').length < 6) {
                              return 'Use pelo menos 6 caracteres.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _carregando ? null : _enviar,
                            child: _carregando
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    _criandoConta ? 'Criar conta' : 'Entrar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _carregando
                        ? null
                        : () {
                            setState(() => _criandoConta = !_criandoConta);
                          },
                    child: Text(
                      _criandoConta
                          ? 'Já tenho uma conta'
                          : 'Ainda não tenho conta',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

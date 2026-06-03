import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../main.dart';
import '../../services/auth_service.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import '../../mainscreen.dart';
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
<<<<<<< HEAD
=======

>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
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

<<<<<<< HEAD
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
=======
    try {
      if (_criandoConta) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );
      }

      else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Erro ao autenticar';

      switch (e.code) {
        case 'email-already-in-use':
          mensagem = 'Esse email já está em uso';
          break;
        case 'user-not-found':
          mensagem = 'Usuário não encontrado';
          break;
        case 'wrong-password':
          mensagem = 'Senha incorreta';
          break;
        case 'invalid-email':
          mensagem = 'Email inválido';
          break;
        case 'weak-password':
          mensagem = 'Senha muito fraca';
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro inesperado: $e')),
        );
      }
    }

    if (!mounted) return;
    setState(() => _carregando = false);
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
<<<<<<< HEAD
    final textoPrincipal =
        Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
=======

    final texto =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;

>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
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
<<<<<<< HEAD
                  Image.asset('assets/icon3.png', height: 86),
                  const SizedBox(height: 18),
=======
                  const SizedBox(height: 20),

>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                  Text(
                    _criandoConta ? 'Criar conta' : 'Entrar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
<<<<<<< HEAD
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
=======
                      color: texto,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _criandoConta
                        ? 'Crie sua conta para continuar'
                        : 'Bem-vindo de volta',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
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
<<<<<<< HEAD
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
=======
                            decoration: const InputDecoration(
                              labelText: 'Nome de usuário',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (v) {
                              if ((v ?? '').trim().length < 2) {
                                return 'Digite um nome válido';
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                        ],
<<<<<<< HEAD
=======

>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
<<<<<<< HEAD
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (valor) {
                            final email = valor?.trim() ?? '';
                            if (!email.contains('@') || !email.contains('.')) {
                              return 'Digite um email válido.';
=======
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (v) {
                            if (!(v ?? '').contains('@')) {
                              return 'Email inválido';
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                            }
                            return null;
                          },
                        ),
<<<<<<< HEAD
                        const SizedBox(height: 14),
=======

                        const SizedBox(height: 14),

>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                        TextFormField(
                          controller: _senhaController,
                          obscureText: _ocultarSenha,
                          decoration: InputDecoration(
                            labelText: 'Senha',
<<<<<<< HEAD
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
=======
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _ocultarSenha
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _ocultarSenha = !_ocultarSenha;
                                });
                              },
                            ),
                          ),
                          validator: (v) {
                            if ((v ?? '').length < 6) {
                              return 'Senha mínima de 6 caracteres';
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                            }
                            return null;
                          },
                        ),
<<<<<<< HEAD
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
=======

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _carregando ? null : _enviar,
                            child: _carregando
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    _criandoConta ? 'Criar conta' : 'Entrar',
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
<<<<<<< HEAD
=======

>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
                  TextButton(
                    onPressed: _carregando
                        ? null
                        : () {
<<<<<<< HEAD
                            setState(() => _criandoConta = !_criandoConta);
                          },
                    child: Text(
                      _criandoConta
                          ? 'Já tenho uma conta'
                          : 'Ainda não tenho conta',
=======
                            setState(() {
                              _criandoConta = !_criandoConta;
                            });
                          },
                    child: Text(
                      _criandoConta
                          ? 'Já tenho conta'
                          : 'Criar nova conta',
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc

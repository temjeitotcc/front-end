import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../mainscreen.dart';
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

  Future<void> _loginComGoogle() async {
    setState(() => _carregando = true);

    try {
      final googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
      );

      await googleSignIn.disconnect().catchError((_) {});
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final credencial =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final nome = credencial.user?.displayName ?? googleUser.displayName;
      if (nome != null) {
        await AuthService.salvarNomeUsuario(nome);
      }
      if (!mounted) return;
      _abrirAplicativo();
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível entrar com o Google.'),
        ),
      );
      debugPrint('Erro Google login: $erro');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _enviar() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    setState(() => _carregando = true);

    try {
      if (_criandoConta) {
        final credencial = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _senhaController.text,
            );

        await credencial.user?.updateDisplayName(
          _nomeUsuarioController.text.trim(),
        );
        await AuthService.salvarNomeUsuario(
          _nomeUsuarioController.text.trim(),
        );
        await FirebaseAuth.instance.currentUser?.reload();
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text,
        );
        await AuthService.nomeUsuarioAtual();
      }

      if (!mounted) return;
      _abrirAplicativo();
    } on FirebaseAuthException catch (erro) {
      debugPrint(
        'FirebaseAuth login: code=${erro.code}, message=${erro.message}',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_mensagemErroFirebase(erro.code))),
      );
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $erro')),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  String _mensagemErroFirebase(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Esse e-mail já está em uso.';
      case 'user-not-found':
        return 'E-mail não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'E-mail ou senha incorretos. Se você criou a conta pelo Google, '
            'use o botão "Continuar com Google".';
      case 'missing-email':
        return 'E-mail não encontrado.';
      case 'missing-password':
        return 'Senha não encontrada.';
      case 'operation-not-allowed':
        return 'O login por e-mail e senha não está habilitado no Firebase.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro ao autenticar.';
    }
  }

  void _abrirAplicativo() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black87;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;
    final borda = escuro ? Colors.white24 : Colors.black12;

    return Scaffold(
      backgroundColor: fundo,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/login_background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(145),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  18,
                  MediaQuery.paddingOf(context).top + 12,
                  18,
                  14,
                ),
                decoration: BoxDecoration(
                  color: corTema.withAlpha(235),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(45),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Text(
                        'Tem Jeito e Vale a Pena',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borda),
                              ),
                              child: _AuthModeSelector(
                                criandoConta: _criandoConta,
                                cor: corTema,
                                enabled: !_carregando,
                                onChanged: (criandoConta) {
                                  if (criandoConta == _criandoConta) return;
                                  FocusScope.of(context).unfocus();
                                  setState(() => _criandoConta = criandoConta);
                                },
                              ),
                            ),
                            const SizedBox(height: 22),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 320),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                final deslocamento = Tween<Offset>(
                                  begin: Offset(
                                    _criandoConta ? 0.08 : -0.08,
                                    0,
                                  ),
                                  end: Offset.zero,
                                ).animate(animation);
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: deslocamento,
                                    child: child,
                                  ),
                                );
                              },
                              child: Column(
                                key: ValueKey(_criandoConta),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _criandoConta
                                        ? 'Comece sua jornada'
                                        : 'Que bom ter você de volta',
                                    style: TextStyle(
                                      color: textoPrincipal,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _criandoConta
                                        ? 'Crie sua conta para guardar seu progresso.'
                                        : 'Entre para continuar de onde parou.',
                                    style: TextStyle(
                                      color: textoSecundario,
                                      fontSize: 14,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: cardColor.withAlpha(238),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: corTema.withAlpha(95),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(45),
                                    blurRadius: 14,
                                    offset: const Offset(0, 7),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  AnimatedSize(
                                    duration:
                                        const Duration(milliseconds: 330),
                                    curve: Curves.easeInOutCubic,
                                    alignment: Alignment.topCenter,
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 260),
                                      transitionBuilder: (child, animation) {
                                        return SizeTransition(
                                          sizeFactor: animation,
                                          axisAlignment: -1,
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: _criandoConta
                                          ? Padding(
                                              key: const ValueKey(
                                                'campo_nome',
                                              ),
                                              padding: const EdgeInsets.only(
                                                bottom: 14,
                                              ),
                                              child: TextFormField(
                                                controller:
                                                    _nomeUsuarioController,
                                                textInputAction:
                                                    TextInputAction.next,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration: _decoracaoCampo(
                                                  context,
                                                  label: 'Nome de usuário',
                                                  icon: Icons
                                                      .person_outline_rounded,
                                                ),
                                                validator: (valor) {
                                                  if (!_criandoConta) {
                                                    return null;
                                                  }
                                                  final nome =
                                                      valor?.trim() ?? '';
                                                  if (nome.length < 2) {
                                                    return 'Digite seu nome de usuário.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )
                                          : const SizedBox(
                                              key: ValueKey('sem_campo_nome'),
                                            ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autocorrect: false,
                                    decoration: _decoracaoCampo(
                                      context,
                                      label: 'E-mail',
                                      icon: Icons.email_outlined,
                                    ),
                                    validator: (valor) {
                                      final email = valor?.trim() ?? '';
                                      if (email.isEmpty) {
                                        return 'E-mail não encontrado.';
                                      }
                                      if (!email.contains('@') ||
                                          !email.contains('.')) {
                                        return 'Digite um e-mail válido.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    controller: _senhaController,
                                    obscureText: _ocultarSenha,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      if (!_carregando) _enviar();
                                    },
                                    decoration: _decoracaoCampo(
                                      context,
                                      label: 'Senha',
                                      icon: Icons.lock_outline_rounded,
                                      suffixIcon: IconButton(
                                        tooltip: _ocultarSenha
                                            ? 'Mostrar senha'
                                            : 'Ocultar senha',
                                        icon: Icon(
                                          _ocultarSenha
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () => _ocultarSenha =
                                                !_ocultarSenha,
                                          );
                                        },
                                      ),
                                    ),
                                    validator: (valor) {
                                      final senha = valor ?? '';
                                      if (senha.isEmpty) {
                                        return 'Senha não encontrada.';
                                      }
                                      if (senha.length < 6) {
                                        return 'Use pelo menos 6 caracteres.';
                                      }
                                      return null;
                                    },
                                  ),
                                  if (!_criandoConta) ...[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _carregando
                                            ? null
                                            : _redefinirSenha,
                                        child: const Text(
                                          'Esqueci minha senha',
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: corTema,
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed:
                                          _carregando ? null : _enviar,
                                      icon: _carregando
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Icon(
                                              _criandoConta
                                                  ? Icons
                                                      .person_add_alt_1_rounded
                                                  : Icons.login_rounded,
                                            ),
                                      label: Text(
                                        key: ValueKey(
                                          'acao_${_carregando}_$_criandoConta',
                                        ),
                                        _carregando
                                            ? 'AGUARDE...'
                                            : _criandoConta
                                                ? 'CRIAR CONTA'
                                                : 'ENTRAR',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 17),
                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: borda)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          'OU',
                                          style: TextStyle(
                                            color: textoSecundario,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Divider(color: borda)),
                                    ],
                                  ),
                                  const SizedBox(height: 17),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton.icon(
                                      onPressed: _carregando
                                          ? null
                                          : _loginComGoogle,
                                      icon: const Icon(
                                        Icons.g_mobiledata_rounded,
                                        size: 29,
                                      ),
                                      label: const Text(
                                        'CONTINUAR COM GOOGLE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: textoPrincipal,
                                        side: BorderSide(color: borda),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracaoCampo(
    BuildContext context, {
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final borda = escuro ? Colors.white24 : Colors.black12;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: escuro
          ? Colors.white.withAlpha(8)
          : Colors.black.withAlpha(5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borda),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: corTema, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
    );
  }

  Future<void> _redefinirSenha() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um e-mail válido para recuperar sua senha.'),
        ),
      );
      return;
    }

    setState(() => _carregando = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Se este e-mail possui uma conta com senha, você receberá '
            'as instruções de recuperação.',
          ),
        ),
      );
    } on FirebaseAuthException catch (erro) {
      debugPrint(
        'FirebaseAuth reset: code=${erro.code}, message=${erro.message}',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_mensagemErroFirebase(erro.code))),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }
}

class _AuthModeSelector extends StatelessWidget {
  final bool criandoConta;
  final Color cor;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _AuthModeSelector({
    required this.criandoConta,
    required this.cor,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth / 2;

        return Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 340),
              curve: Curves.easeInOutCubic,
              alignment: criandoConta
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: largura - 8,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: cor.withAlpha(70),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _SelectorLabel(
                    label: 'Entrar',
                    selecionado: !criandoConta,
                    texto: texto,
                    enabled: enabled,
                    onTap: () => onChanged(false),
                  ),
                ),
                Expanded(
                  child: _SelectorLabel(
                    label: 'Criar conta',
                    selecionado: criandoConta,
                    texto: texto,
                    enabled: enabled,
                    onTap: () => onChanged(true),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SelectorLabel extends StatelessWidget {
  final String label;
  final bool selecionado;
  final Color texto;
  final bool enabled;
  final VoidCallback onTap;

  const _SelectorLabel({
    required this.label,
    required this.selecionado,
    required this.texto,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(9),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 240),
            style: TextStyle(
              color: selecionado ? Colors.black : texto,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

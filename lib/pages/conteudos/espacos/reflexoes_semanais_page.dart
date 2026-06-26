import 'package:flutter/material.dart';

import '../../../services/firebase_reflexoes_service.dart';
import '../../../widgets/main_tab_header.dart';
import '../conteudos_utils.dart';
import 'desafios_feitos_page.dart';
import '../../../services/conteudos_service.dart';

class ReflexoesSemanaisPage extends StatefulWidget {
  const ReflexoesSemanaisPage({super.key});

  @override
  State<ReflexoesSemanaisPage> createState() => _ReflexoesSemanaisPageState();
}

class _ReflexoesSemanaisPageState extends State<ReflexoesSemanaisPage> {
  final FirebaseReflexoesService service = FirebaseReflexoesService();

  Map<int, ConteudoDesafio> conteudos = {};
  bool carregando = true;

  static const List<int> missoesEspeciais = [7, 14, 21, 28];

  @override
  void initState() {
    super.initState();
    carregarReflexoes();
  }

  Future<void> carregarReflexoes() async {
    final dados = await service.carregarReflexoes();

    if (!mounted) return;

    setState(() {
      conteudos = dados;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Reflexões da semana',
            subtitle: 'Revisite as decisões que marcaram sua jornada',
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          Expanded(
            child: carregando
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
                    itemCount: missoesEspeciais.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final numero = missoesEspeciais[index];
                      final numeroSemana = index + 1;
                      final conteudo = conteudos[numero];
                      final temConteudo =
                          conteudo != null && conteudo.itens.isNotEmpty;

                      return ListTile(
                        onTap: temConteudo
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ConteudoDesafioPage(conteudo: conteudo),
                                  ),
                                );
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: temConteudo
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white.withAlpha(20),
                          ),
                        ),
                        tileColor: temConteudo
                            ? const Color(0xFF2A2527)
                            : const Color(0xFF211D1F),
                        leading: CircleAvatar(
                          backgroundColor: temConteudo
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white24,
                          foregroundColor: Colors.black,
                          child: const Icon(Icons.auto_awesome_rounded),
                        ),
                        title: Text(
                          'Reflexão da semana $numeroSemana',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: temConteudo
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      formatarDataHoraBrasilia(
                                        conteudo.atualizadoEm,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Horário exibido no fuso de Brasília (BRT).',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Text(
                                'Nada escrito ainda',
                                style: TextStyle(color: Colors.white60),
                              ),
                        trailing: Icon(
                          temConteudo
                              ? Icons.chevron_right_rounded
                              : Icons.lock_outline_rounded,
                          color: temConteudo
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white38,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

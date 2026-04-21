import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1819),

      body: Column(
        children: [
          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFFED23E),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: const Center(
              child: Text(
                "Configurações",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // 🔥 LISTA
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _secaoTitulo("Conta"),
                _item(Icons.person, "Perfil"),
                _item(Icons.lock, "Privacidade"),

                const SizedBox(height: 20),

                _secaoTitulo("Aplicativo"),
                _item(Icons.notifications, "Notificações"),
                _item(Icons.palette, "Tema"),
                _item(Icons.language, "Idioma"),

                const SizedBox(height: 20),

                _secaoTitulo("Outros"),
                _item(Icons.help, "Ajuda"),
                _item(Icons.info, "Sobre"),
                _item(Icons.logout, "Sair"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 TÍTULO DE SEÇÃO
  Widget _secaoTitulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 🔥 ITEM BONITO
  Widget _item(IconData icone, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFF2A2727),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            print("$texto clicado");
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                // ÍCONE
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFED23E).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icone, color: const Color(0xFFFED23E)),
                ),

                const SizedBox(width: 15),

                // TEXTO
                Expanded(
                  child: Text(
                    texto,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                // SETA
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white38,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          // 🔥 TOPO (COM IMAGEM)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFFFED23E),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Image.asset('assets/iconloja.png', height: 34),
                const SizedBox(height: 8),
                const Text(
                  'Lojinha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // CONTEÚDO
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 💰 CARD DE PONTOS
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2526),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PONTOS:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '100',
                                  style: TextStyle(
                                    color: Color(0xFFFED23E),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.star, color: Color(0xFFFED23E)),
                              ],
                            ),
                          ],
                        ),

                        // 🐱 imagem lateral
                        Image.asset('assets/icon4.png', height: 60),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // GRID DE ITENS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.75,
                      children: const [
                        ItemCard(
                          nome: "Cartola",
                          preco: 50,
                          imagem: "assets/loja1.png",
                        ),
                        ItemCard(
                          nome: "Cachecol",
                          preco: 50,
                          imagem: "assets/loja2.png",
                        ),
                        ItemCard(
                          nome: "Óculos",
                          preco: 65,
                          imagem: "assets/loja3.png",
                        ),
                        ItemCard(
                          nome: "Touca",
                          preco: 50,
                          imagem: "assets/loja4.png",
                        ),
                        ItemCard(
                          nome: "Casaco",
                          preco: 75,
                          imagem: "assets/loja5.png",
                        ),
                        ItemCard(
                          nome: "Fundo",
                          preco: 150,
                          imagem: "assets/loja6.png",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 CARD DOS ITENS
class ItemCard extends StatelessWidget {
  final String nome;
  final int preco;
  final String imagem;

  const ItemCard({
    super.key,
    required this.nome,
    required this.preco,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2526),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset(imagem, fit: BoxFit.contain)),

          Text(nome, style: const TextStyle(color: Colors.white)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$preco',
                style: const TextStyle(
                  color: Color(0xFFFED23E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 16, color: Color(0xFFFED23E)),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AranhaversoApp());
}

class AranhaversoApp extends StatelessWidget {
  const AranhaversoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aranhaverso App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B0000), // Vermelho Escuro
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final String historiaTexto =
      '"A lore de Homem-Aranha no Aranhaverso acompanha Miles Morales, um adolescente do Brooklyn que ganha superpoderes após ser picado por uma aranha geneticamente modificada. Pouco tempo depois, ele testemunha o Homem-Aranha de sua dimensão, o herói Peter Parker, ser assassinado pelo vilão Rei do Crime (Wilson Fisk).\n\n'
      'Antes de morrer, o Peter Parker original entrega a Miles uma chave eletrônica capaz de destruir a máquina antes que ela colapse a realidade. É a partir do primeiro disparo do Colisor que cinco variantes do herói de outras dimensões são puxadas para a Nova York de Miles.\n\n'
      'Na batalha final, Miles ressurge completamente transformado em herói. Ele se junta ao grupo de variantes, ajuda a derrotar os capangas do Rei do Crime e envia cada um dos heróis de volta para suas respectivas dimensões natais."';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homem-Aranha no Aranhaverso', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formatado para manter a proporção do pôster sem esticar
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/pt/3/33/Spider-Man_Into_the_spider-verse_poster_c%C3%B3pia.png',
                  fit: BoxFit.contain, // Mantém a proporção correta do cartaz/pôster
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xFF8B0000),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoriaScreen(historia: historiaTexto)),
                );
              },
              child: const Text('História do Filme', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xFF8B0000),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ElencoScreen()),
                );
              },
              child: const Text('Elenco Principal', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xFF8B0000),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CuriosidadesScreen()),
                );
              },
              child: const Text('Curiosidades', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class ElencoScreen extends StatelessWidget {
  const ElencoScreen({super.key});

  Future<List<dynamic>> _carregarElencoJson() async {
    final String resposta = await rootBundle.loadString('assets/json/elenco.json');
    return jsonDecode(resposta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elenco Principal', style: TextStyle(color: Colors.white))),
      body: FutureBuilder<List<dynamic>>(
        future: _carregarElencoJson(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final elencoList = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: elencoList.length,
                  itemBuilder: (context, index) {
                    final item = elencoList[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Formatação da imagem do Ator
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40), // Deixa a imagem redonda
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      color: Colors.grey[300],
                                      child: Image.network(
                                        item['imagem_ator'],
                                        fit: BoxFit.cover, // Preenche a área do quadrado/círculo sem distorcer
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.person, size: 40, color: Colors.grey);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Ator', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_rounded, color: Color(0xFF8B0000)),
                              // Formatação da imagem do Personagem
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40), // Deixa a imagem redonda
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      color: Colors.grey[300],
                                      child: Image.network(
                                        item['imagem_personagem'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.person, size: 40, color: Colors.grey);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Personagem', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(item['ator'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Papel: ${item['papel']}', style: const TextStyle(color: Color(0xFF8B0000))),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(item['wiki']), mode: LaunchMode.externalApplication),
                            child: const Text(
                              'Abrir Wikipedia',
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: const Color(0xFF8B0000),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CuriosidadesScreen extends StatelessWidget {
  const CuriosidadesScreen({super.key});

  Future<List<dynamic>> _carregarCuriosidadesJson() async {
    final String resposta = await rootBundle.loadString('assets/json/curiosidades.json');
    return jsonDecode(resposta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Curiosidades', style: TextStyle(color: Colors.white))),
      body: FutureBuilder<List<dynamic>>(
        future: _carregarCuriosidadesJson(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final curiosidades = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => launchUrl(Uri.parse('https://www.disney.com.br/novidades/curiosidades-sobre-sobre-homem-aranha-no-aranhaverso-disponivel-no-disney-plus'), mode: LaunchMode.externalApplication),
                  child: const Text(
                    'Fonte: Disney',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: curiosidades.length,
                    itemBuilder: (context, index) {
                      final item = curiosidades[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['titulo'],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B0000)),
                            ),
                            const SizedBox(height: 5),
                            Text(item['descricao']),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: const Color(0xFF8B0000),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HistoriaScreen extends StatelessWidget {
  final String historia;

  const HistoriaScreen({super.key, required this.historia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('História do Filme', style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(historia, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: const Color(0xFF8B0000),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastVolumeControl extends StatefulWidget {
  final AudioPlayer player;

  const PodcastVolumeControl({
    super.key,
    required this.player,
  });

  @override
  State<PodcastVolumeControl> createState() =>
      _PodcastVolumeControlState();
}

class _PodcastVolumeControlState extends State<PodcastVolumeControl> {
  double volume = 50;

  @override
  void initState() {
    super.initState();
    _carregarVolume();
  }

  Future<void> _carregarVolume() async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = (prefs.getDouble('volume') ?? 50).clamp(0, 100).toDouble();
    await widget.player.setVolume(salvo / 100);
    if (!mounted) return;
    setState(() => volume = salvo);
  }

  Future<void> _alterarVolume(double valor) async {
    setState(() => volume = valor);
    await widget.player.setVolume(valor / 100);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', valor);
  }

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Row(
      children: [
        Icon(
          volume == 0
              ? Icons.volume_off_rounded
              : volume < 50
                  ? Icons.volume_down_rounded
                  : Icons.volume_up_rounded,
          color: corTema,
          size: 23,
        ),
        Expanded(
          child: Slider(
            value: volume,
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: corTema,
            inactiveColor: textoSecundario.withAlpha(55),
            label: '${volume.round()}%',
            onChanged: _alterarVolume,
          ),
        ),
        SizedBox(
          width: 42,
          child: Text(
            '${volume.round()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: textoSecundario,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

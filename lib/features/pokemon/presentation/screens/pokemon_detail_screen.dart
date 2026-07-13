import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesys21_app_pokemon/core/utils/string_extensions.dart';
import '../../../../core/utils/pokemon_type_color.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/entities/pokemon_detail_entity.dart';
import '../providers/pokemon_provider.dart';

class PokemonDetailScreen extends StatelessWidget {
  final PokemonResultEntity pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Color> backgroundColorNotifier = ValueNotifier<Color>(
      Theme.of(context).primaryColor,
    );
    return ValueListenableBuilder<Color>(
      valueListenable: backgroundColorNotifier,
      builder: (context, currentBackgroundColor, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          color: currentBackgroundColor,
          child: Stack(
            children: [
              _buildPokeballBackground(),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: _buildAppBar(context),
                body: Stack(
                  children: [
                    _buildContentPokemonDetail(
                      context,
                      backgroundColorNotifier,
                    ),
                    _buildPokemonImg(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPokeballBackground() {
    return Positioned(
      top: 50,
      right: 0,
      child: Opacity(
        opacity: 0.1,
        child: Image.asset(
          "assets/pokemon_icons/pokeball_background.png",
          height: 250,
          fit: BoxFit.contain,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        pokemon.name.capitalizeString,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Center(
            child: Text(
              '#${pokemon.pokemonId.toString().padLeft(3, '0')}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentPokemonDetail(
    BuildContext context,
    ValueNotifier<Color> backgroundColorNotifier,
  ) {
    return Positioned.fill(
      top: 200,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: FutureBuilder<PokemonDetailEntity>(
            future: context.read<PokemonProvider>().loadPokemonDetail(
              pokemon.pokemonId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No se encontró información'));
              }
              final detail = snapshot.data!;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final targetColor = PokemonTypeColors.getColor(
                  detail.types.first,
                );
                if (backgroundColorNotifier.value != targetColor) {
                  backgroundColorNotifier.value = targetColor;
                }
              });
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 56,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    // Tipos de Pokémon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: detail.types
                          .map((type) => _buildTypeChip(type))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Acerca de (Peso, Altura, Movimientos)
                    _buildContentAcercaDe(detail),
                    const SizedBox(height: 16),

                    // Descripción
                    Text(
                      detail.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Estadísticas
                    _buildContentStats(detail),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: PokemonTypeColors.getColor(type),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type[0].toUpperCase() + type.substring(1),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildContentAcercaDe(PokemonDetailEntity detail) {
    return Column(
      children: [
        Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: PokemonTypeColors.getColor(detail.types.first),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildInfoItem(
              "assets/pokemon_icons/peso_icon.png",
              '${detail.weight} kg',
              'Weight',
            ),
            _buildVerticalDivider(),
            _buildInfoItem(
              "assets/pokemon_icons/altura_icon.png",
              '${detail.height} m',
              'Height',
            ),
            _buildVerticalDivider(),
            _buildInfoItem(
              null,
              detail.abilities
                  .map((a) => a[0].toUpperCase() + a.substring(1))
                  .join('\n'),
              'Moves',
              isMultiline: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    String? imageIcon,
    String value,
    String label, {
    bool isMultiline = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (imageIcon != null)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.asset(imageIcon, height: 15),
                    )
                  : SizedBox.shrink(),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  height: isMultiline ? 1.3 : 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 50, width: 1, color: Colors.grey[300]);
  }

  Widget _buildContentStats(PokemonDetailEntity detail) {
    final colorStats = PokemonTypeColors.getColor(detail.types.first);
    return Column(
      children: [
        Text(
          'Base Stats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorStats,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: detail.stats.entries.map((stat) {
            return _buildStatRow(stat.key, stat.value, colorStats);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    final double targetValue = value.toDouble();
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          height: 24,
          width: 1,
          color: Colors.grey[300],
          margin: const EdgeInsets.symmetric(horizontal: 12),
        ),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: targetValue),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            builder: (context, animatedValue, _) {
              return Row(
                children: [
                  SizedBox(
                    width: 35,
                    child: Text(
                      animatedValue.toInt().toString().padLeft(3, '0'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: animatedValue / 150,
                        backgroundColor: color.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPokemonImg() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Hero(
        tag: 'pokemon-img-${pokemon.pokemonId}',
        child: Image.network(
          pokemon.imageUrl,
          height: 240,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

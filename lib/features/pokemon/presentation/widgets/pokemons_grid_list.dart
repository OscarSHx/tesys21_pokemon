import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/string_extensions.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../providers/pokemon_provider.dart';
import '../screens/pokemon_detail_screen.dart';

class PokemonsGridList extends StatefulWidget {
  final PokemonEntity entity;

  const PokemonsGridList({super.key, required this.entity});

  @override
  State<PokemonsGridList> createState() => _PokemonsGridListState();
}

class _PokemonsGridListState extends State<PokemonsGridList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<PokemonProvider>().loadNextPagePokemons();
    }
  }

  @override
  Widget build(BuildContext context) {
    log('✅ Se obtuvieron ${widget.entity.results.length} pokemones');
    final isLoadingPage = context.select<PokemonProvider, bool>(
      (provider) => provider.isLoadingPage,
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: widget.entity.results.length,
          itemBuilder: (context, index) {
            final pokemon = widget.entity.results[index];
            return _buildPokemonCard(pokemon, index);
          },
        ),
        // Loding Página Siguiente
        if (isLoadingPage)
          Positioned(
            bottom: 0,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPokemonCard(PokemonResultEntity pokemon, int index) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailScreen(pokemon: pokemon),
            ),
          );
        },
        child: Stack(
          children: [
            // Fondo de la tarjeta
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Número de Pokémon
                  Text(
                    '#${pokemon.pokemonId.toString().padLeft(3, '0')}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  // Imagen de Pokémon
                  Expanded(
                    child: Center(
                      child: Hero(
                        tag: 'pokemon-img-${pokemon.pokemonId}',
                        child: FadeInImage.assetNetwork(
                          placeholder:
                              "assets/pokemon_icons/pokeball_black.png",
                          image: pokemon.imageUrl,
                          fit: BoxFit.contain,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Nombre de Pokémon
                  Text(
                    pokemon.name.capitalizeString,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

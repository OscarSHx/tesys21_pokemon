import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesys21_app_pokemon/core/widgets/custom_error_widget.dart';
import 'package:tesys21_app_pokemon/core/widgets/custom_loading_widgtet.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemons_grid_list.dart';
import '../widgets/sort_dialog.dart';

class PokemonScreen extends StatelessWidget {
  const PokemonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBarAndFilter(context),
              _buildContentPokemonList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Image.asset("assets/pokemon_icons/pokeball_white.png"),
          const SizedBox(width: 16),
          const Text(
            'Pokédex',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBarAndFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar Pokémon',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  context.read<PokemonProvider>().setSearchQuery(value);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 45,
            width: 45,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Consumer<PokemonProvider>(
              builder: (context, provider, child) {
                final String iconSelected =
                    (provider.currentOrder == PokemonOrder.name)
                    ? "assets/pokemon_icons/name_icon.png"
                    : "assets/pokemon_icons/number_icon.png";
                return IconButton(
                  icon: Image.asset(
                    iconSelected,
                    color: Theme.of(context).colorScheme.primary,
                    height: 24,
                  ),
                  onPressed: () {
                    log('🔘 Abrir Sort Dialog');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const SortDialog(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPokemonList() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Consumer<PokemonProvider>(
          builder: (context, provider, child) {
            if (!provider.isLoading &&
                provider.pokemonEntity == null &&
                provider.errorMessage.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                provider.loadPokemons();
              });
            }

            if (provider.isLoading) {
              log('⏳ Obteniendo pokemones');
              return const CustomLoadingWidget();
            }

            if (provider.errorMessage.isNotEmpty) {
              log('❌ Error obteniendo pokemones: ${provider.errorMessage}');
              return CustomErrorWidget(
                errorMessage: provider.errorMessage,
                onCallback: () => provider.loadPokemons(),
              );
            }

            final entity = provider.pokemonEntity;
            if (entity == null || entity.results.isEmpty) {
              return const Center(child: Text('No se obtuvieron pokemones.'));
            }

            return PokemonsGridList(entity: entity);
            // return _buildPokemonesGrid(entity);
          },
        ),
      ),
    );
  }
}

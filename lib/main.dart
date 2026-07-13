import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:tesys21_app_pokemon/core/theme/app_theme.dart';
import 'package:tesys21_app_pokemon/features/pokemon/data/datasources/pokemones_datasource.dart';
import 'package:tesys21_app_pokemon/features/pokemon/data/repositories/pokemones_repository_impl.dart';
import 'package:tesys21_app_pokemon/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:tesys21_app_pokemon/features/pokemon/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:tesys21_app_pokemon/features/pokemon/domain/usecases/get_pokemones_usecases.dart';
import 'package:tesys21_app_pokemon/features/pokemon/presentation/providers/pokemon_provider.dart';
import 'package:tesys21_app_pokemon/features/pokemon/presentation/screens/pokemons_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://pokeapi.co/api/v2',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    return MultiProvider(
      providers: [
        // Dio a DataSource
        Provider<PokemonRemoteDataSource>(
          create: (_) => PokemonRemoteDataSourceImpl(dio),
        ),

        // DataSource a Repositorio
        ProxyProvider<PokemonRemoteDataSource, PokemonRepository>(
          update: (_, dataSource, _) =>
              PokemonRepositoryImpl(remoteDataSource: dataSource),
        ),

        // Repositorio al Caso de Uso
        ProxyProvider<PokemonRepository, GetPokemonsUseCase>(
          update: (_, repository, _) => GetPokemonsUseCase(repository),
        ),
        ProxyProvider<PokemonRepository, GetPokemonDetailUseCase>(
          update: (_, repository, _) => GetPokemonDetailUseCase(repository),
        ),

        // Caso de Uso a su ChangeNotifierProvider
        ChangeNotifierProvider<PokemonProvider>(
          create: (context) => PokemonProvider(
            getPokemonsUseCase: context.read<GetPokemonsUseCase>(),
            getPokemonDetailUseCase: context.read<GetPokemonDetailUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        title: 'Pokédex',
        home: PokemonScreen(),
      ),
    );
  }
}

import '../../domain/entities/pokemon_detail_entity.dart';

class PokemonDetailModel extends PokemonDetailEntity {
  const PokemonDetailModel({
    required super.id,
    required super.name,
    required super.weight,
    required super.height,
    required super.types,
    required super.abilities,
    required super.stats,
    required super.description,
  });

  factory PokemonDetailModel.fromJson({
    required Map<String, dynamic> pokemonJson,
    required Map<String, dynamic> speciesJson,
  }) {
    final List<String> types = (pokemonJson['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    final List<String> abilities = (pokemonJson['abilities'] as List)
        .map((a) => a['ability']['name'] as String)
        .toList();

    final Map<String, int> stats = {};
    final List rawStats = pokemonJson['stats'] as List;

    // Mapeo nativo de PokeAPI a las siglas de tu UI
    final Map<String, String> statMap = {
      'hp': 'HP',
      'attack': 'ATK',
      'defense': 'DEF',
      'special-attack': 'SATK',
      'special-defense': 'SDEF',
      'speed': 'SPD',
    };

    for (var s in rawStats) {
      final String apiName = s['stat']['name'];
      if (statMap.containsKey(apiName)) {
        stats[statMap[apiName]!] = s['base_stat'] as int;
      }
    }

    final List textEntries = speciesJson['flavor_text_entries'] as List;
    final String description =
        textEntries.firstWhere(
              (entry) => entry['language']['name'] == 'es',
              orElse: () => {'flavor_text': 'No description available.'},
            )['flavor_text']
            as String;

    return PokemonDetailModel(
      id: pokemonJson['id'] as int,
      name: pokemonJson['name'] as String,
      weight: (pokemonJson['weight'] as int) / 10,
      height: (pokemonJson['height'] as int) / 10,
      types: types,
      abilities: abilities,
      stats: stats,
      description: description.replaceAll('\n', ' ').replaceAll('\f', ' '),
    );
  }
}

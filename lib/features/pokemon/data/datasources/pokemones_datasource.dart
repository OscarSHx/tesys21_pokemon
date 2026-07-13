import 'package:dio/dio.dart';
import 'package:tesys21_app_pokemon/core/utils/utils.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<PokemonModel> getPokemonesFromApi({int offset = 0, int limit = 20});

  Future<PokemonDetailModel> getPokemonDetailFromApi(int id);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final Dio _dio;
  PokemonRemoteDataSourceImpl(this._dio);

  @override
  Future<PokemonModel> getPokemonesFromApi({
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/pokemon?limit=$limit&offset=$offset');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return PokemonModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (dioError) {
      final errorMessage = Utils.handleDioError(dioError);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error en DataSource - getPokemonesFromApi: $e');
    }
  }

  @override
  Future<PokemonDetailModel> getPokemonDetailFromApi(int id) async {
    try {
      final responses = await Future.wait([
        _dio.get('https://pokeapi.co/api/v2/pokemon/$id'),
        _dio.get('https://pokeapi.co/api/v2/pokemon-species/$id'),
      ]);

      return PokemonDetailModel.fromJson(
        pokemonJson: responses[0].data,
        speciesJson: responses[1].data,
      );
    } on DioException catch (dioError) {
      final errorMessage = Utils.handleDioError(dioError);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error en DataSource - getPokemonDetailFromApi: $e');
    }
  }
}

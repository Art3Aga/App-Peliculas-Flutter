import 'dart:async';
import 'dart:convert';
import 'package:peliculas/src/model/actores_model.dart';
import 'package:peliculas/src/model/pelicula_model.dart';
import 'package:http/http.dart' as http;
class PeliculasProvider{
  String _apiKey = '16c9b2e65237e8d546bdb3a01dc9aca5';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;
  List<Pelicula> _populares = new List();
  //sin el broadCast, solo un widget escuchara la afluencia de informacion
  final _populareStream = StreamController<List<Pelicula>>.broadcast();
  
  //introducir peliculas a la tuberia de datos
  Function (List<Pelicula>)get popularesSink => _populareStream.sink.add;
  //escuchar la informacion
  Stream<List<Pelicula>> get popularesStream => _populareStream.stream;

  void disposeStreams(){
    _populareStream?.close();
  }

  
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language
    });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    //print(decodedData['results']);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }
  Future<List<Pelicula>>getEnCines() async {
    //Todo esto se puede resumir pegando todo el url
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language
    });
    return await _procesarRespuesta(url);
    //print(peliculas.items[0].title);
  }
  Future<List<Pelicula>>getPopulares() async{
    if(_cargando ){
      return [];
    }
    else{
      _cargando = true;
    }
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });
    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
    //return await _procesarRespuesta(url);
  }
  Future<List<Actor>>getCast(String peliId) async{
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>>buscarPelicula(String texto) async {
    //Todo esto se puede resumir pegando todo el url
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': texto
    });
    return await _procesarRespuesta(url);
    //print(peliculas.items[0].title);
  }
}
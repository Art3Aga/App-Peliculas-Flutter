import 'package:flutter/material.dart';
import 'package:peliculas/src/model/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class Buscador extends SearchDelegate{
  final peliculas = [
    'WandaVision', 
    'El Rey Leon',
    'Toy Story 4', 
    'Jhon Wick Chapter 3',
    'AquaMan', 
    'Shazam!',
    ];
  final peliculasRecientes = ['Spider-Man', 'Eternals'];
  final moviesProvider = new PeliculasProvider();
  @override
  List<Widget> buildActions(BuildContext context) {
    //Acciones del Appbar, borrar, limpiar, etc
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del Appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados a mostrar
    return Center(
      child: Container(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return Container();
    }
    else{
      return FutureBuilder(
        future: moviesProvider.buscarPelicula(query),
        builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if(snapshot.hasData){
            final peliculas = snapshot.data;
            return ListView(
              children: 
                peliculas.map((movie){
                  return  ListTile(
                    leading: FadeInImage(
                      image: NetworkImage(movie.getPosterImg()),
                      placeholder: AssetImage('assets/img/loading.gif'),
                      fit: BoxFit.contain,
                    ),
                    title: Text(movie.title),
                    subtitle: Text(movie.originalTitle),
                    onTap: (){
                      close(context, null);
                      movie.unicoId = '';
                      Navigator.of(context).pushNamed('detalle', arguments: movie);
                    },
                  );
                }).toList(),
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
    /*final listaSugerida = (query.isEmpty)? peliculasRecientes: 
    peliculas.where((p)=>p.toLowerCase().startsWith(query.toLowerCase())).toList();
    //Sugerencias que aparecen cuando el usuario escribe
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (BuildContext context, int index) {
      return ListTile(
        leading: Icon(Icons.movie),
        title: Text(listaSugerida[index]),
        onTap: (){},
      );
     },
    );*/
  }
}
import 'package:flutter/material.dart';
import 'package:peliculas/src/model/pelicula_model.dart';
class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function nextPage;
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );
  MovieHorizontal({@required this.peliculas, @required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener((){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        nextPage();
      }
    });
    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        itemCount: peliculas.length,
        itemBuilder: (context, index){
          return _tarjeta(context, peliculas[index]);
        },
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
      ),
    );
  }
  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    pelicula.unicoId = '${pelicula.id}-poster';
    final cardPelicula = Container(
        margin: EdgeInsets.only(right: 10),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.unicoId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                  height: 160,
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context,'detalle', arguments: pelicula);
      },
      child: cardPelicula,
    );
  }

  List<Widget> _todasTarjetas(BuildContext context) {
    return peliculas.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right: 10),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/loading.gif'),
                fit: BoxFit.cover,
                height: 160,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    }).toList();
  }
}
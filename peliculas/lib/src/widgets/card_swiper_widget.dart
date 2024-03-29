import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/model/pelicula_model.dart';
class CardSwiper extends StatelessWidget {
  //const CardSwiper({Key key}) : super(key: key);
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas}); 
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Swiper(
        itemCount: peliculas.length,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context,int index){
          peliculas[index].unicoId = '${peliculas[index].id}-tarjeta';
          return Hero(
            tag: peliculas[index].unicoId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
                },
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        /*pagination: new SwiperPagination(),
        control: new SwiperControl(),*/
      ),
    );
  }
}
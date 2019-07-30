import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key key}) : super(key: key);
  final peliculasProvider = new PeliculasProvider();
  
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en Cines'),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: Buscador());
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if(snapshot.hasData){
          return CardSwiper(
            peliculas: snapshot.data,
          );
        }
        else{
          return Container(
            height: 400,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );
    /*peliculasProvider.getEnCines();
    return CardSwiper(
      peliculas: [1,2,3,4,5],
    );*/
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('Populares', style: Theme.of(context).textTheme.subhead),
            padding: EdgeInsets.only(left: 20),
          ),
          SizedBox(height: 5,),
          //Padding(padding: EdgeInsets.only(bottom: 23),),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              //snapshot.data?.forEach((p)=>print(p.title));
              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  nextPage: peliculasProvider.getPopulares,
                );
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
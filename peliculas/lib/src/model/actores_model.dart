class Cast{
  List<Actor> actores = new List();
  Cast.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null){
      return;
    }
    else{
      jsonList.forEach((item){
        final actor = Actor.fromJsonMap(item);
        actores.add(actor);
      });
    }
  }
}


//Un solo actor
class Actor{
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath
  });

  Actor.fromJsonMap(Map<String, dynamic> json){
    castId =   json['cast_id'];
    character =  json['character'];
    creditId =  json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath =  json['profile_path'];
  }
  getFoto(){
    if(profilePath == null){
      return 'http://dragene.no/wp-content/uploads/2016/06/default1.jpg';
    }
    else{
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
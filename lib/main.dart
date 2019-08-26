import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
 
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplashmin/ui/viewimage.dart';
void main(){ 
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark
     
  ));    
  runApp(MaterialApp(     
    debugShowCheckedModeBanner: false,       
    home: Home(),
    ));
}  

 class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List urls;
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();
TextEditingController _buscar=TextEditingController();
String busqueda='Girl';
  Future<List> _getImages(String busca)async{
      var url='https://api.unsplash.com/search/photos/?client_id=c7e125a52a3ce6bfc3830c1dab951ee6d1fa2a06980873f9d894ad615e197df8&query=$busca&page=1&per_page=50';    
      //https://api.unsplash.com/photos/?client_id=c7e125a52a3ce6bfc3830c1dab951ee6d1fa2a06980873f9d894ad615e197df8
      var response=await http.get(url);
      print(response.body);
      var respuesta=jsonDecode(response.body)['results'];
      // print('${response.body}');
      urls=respuesta;      
       return urls;
    
  }

  Future<Null> _refresh(){
    return _getImages(busqueda).then((_url){
      setState(() =>urls=_url);
    });
  }

  void _handleSubmission(String text) {
    busqueda=text;
    return print('$text');
    
// Not triggered when you press enter on keyboard in  android simulator
// Triggers if you tap on the Done button.
}
 @override
 void initState(){
   super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_)=>_refreshIndicatorKey.currentState.show());
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          _cabecera(),
          _gritimages(),
        ],
      ),
    );
  }
  Widget _cabecera(){
    return Positioned(
        top: 70,
        width: MediaQuery.of(context).size.width,
        child: Container(
           padding: EdgeInsets.only(left:20,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[                   
                  Icon(Icons.menu),                  
                  CircleAvatar(
                      radius: 15,
                    backgroundImage: AssetImage("images/avatar.png"),
                  )

                ],
              ),
              SizedBox(
                  height:50,
              ),
              Text('Unsplash',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(
                  height:10,
              ),
              Text('Beautiful, free photos.',style: TextStyle(fontSize: 15),),
              SizedBox(
                  height:20,
              ),
              TextField(                
                controller: _buscar,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    
                  ),
                  hintText: 'Search photos'
                ),
              onSubmitted: _handleSubmission,

              )
            ],
          ),
        ),
    );
  }
 Widget _gritimages(){
   return Positioned(
     top: 300,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(left:20,right: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: FutureBuilder(
          future: _getImages(busqueda),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            var fotos=snapshot.data;
            if(snapshot.data==null){
              return Container(
                child: Center(
                  //child: CircularProgressIndicator(),
                ),
              );
            }else{
              return StaggeredGridView.countBuilder(
                  padding: const EdgeInsets.all(3.0),
                  crossAxisCount: 4,
                   itemCount: fotos.length,
                   itemBuilder: (context,index){
                     return Container( 
                          child: GestureDetector(
                            child:ClipRRect(borderRadius: BorderRadius.circular(10),
                           child:Hero(
                             tag:fotos[index]['urls']['small'],
                             child: Image.network('${fotos[index]['urls']['small']}',fit: BoxFit.cover,) 
                          ,),
                           ),
                          onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>ViewImage(fotos[index]['urls']['regular'])));
                          },
                          ),
                     );
                   },
                   staggeredTileBuilder: (i)=>StaggeredTile.count(2,i.isEven?2:3), 
                   mainAxisSpacing: 15,
                   crossAxisSpacing: 15,
              );
            }

          },
        ),
        )
         
      ),
    );
 }

  
}
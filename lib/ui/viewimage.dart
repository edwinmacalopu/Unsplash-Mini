import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
  

 class ViewImage extends StatefulWidget {
   final  fotogrande;
   ViewImage(this.fotogrande);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body: Stack(
        children: <Widget>[
          _viewimage(),
          _buttondow(),
        ],
      )
      );
     
  }
  Widget _viewimage(){
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        child: Center(
        child: Container(
         width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child: ExtendedImage.network(
           '${widget.fotogrande}',
           //scale: 5.0,
           //width: MediaQuery.of(context).size.width,
  //height: MediaQuery.of(context).size.height,
           fit: BoxFit.cover,
  cache: true,
  mode: ExtendedImageMode.Gesture,
   
        )
        ),
      ),
      ),
    );
  }
  Widget _buttondow(){
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.file_download,color: Colors.black,),
        onPressed: (){},
      ),
    );
  }
}
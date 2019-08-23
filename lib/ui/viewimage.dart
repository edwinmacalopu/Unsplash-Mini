import 'package:flutter/material.dart';

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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child: Image.network('${widget.fotogrande}',fit: BoxFit.cover,),
      ),
      )
    );
  }
}
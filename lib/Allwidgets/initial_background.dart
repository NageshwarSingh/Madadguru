import 'package:flutter/material.dart';

  class BackgroundMain extends StatelessWidget {
  const BackgroundMain({Key? key}) : super(key: key);

     @override
     Widget build(BuildContext context) => Stack(
         children: [
       Positioned(
        left: 0,
        top: 0,
       right: 0,
        child: Image.asset('assets/images/EllipseNew.png',
          // "assets/images/Ellipse11.jpg",
          width: MediaQuery.of(context).size.width,
          // height: 100,
        ),
        ),

        Positioned(
        left: 0,
        bottom: 0,
          right: 0,
        child: Image.asset(
          "assets/images/Ellipse22.png",
          // width: 350,
            width: MediaQuery.of(context).size.width,
          //
          // height: 100,
        ),
       ),
      ]
     );

   }


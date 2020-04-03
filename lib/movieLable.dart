import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieLabel extends StatefulWidget {
  @override
  _MovieLabelState createState() => _MovieLabelState();
}

class _MovieLabelState extends State<MovieLabel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Container(
        height: 137,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey[200],
              width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Image(
                    image: AssetImage('assets/logoWithBackgroung.png'),
                  ),),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("Movie Name will be placesd here",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(

                          child: GestureDetector(
                            onTap: (){
                              print("sad");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                borderRadius: BorderRadius.all(Radius.circular(5))
                              ),

                              margin: new EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5,2,0,5),
                                child: Row( // Replace with a Row for horizontal icon + text
                                   children: <Widget>[
                                     Icon(Icons.visibility,
                                     color: Colors.grey[200],),
                                     Text(""" Add to \n Watched List""",

                                     style: TextStyle(
                                       color: Colors.grey[200],
                                         fontWeight: FontWeight.bold
                                     ),)
                                   ],
                                 ),
                              ),
                            ),
                          ),
                            ),
                            Expanded(

                              child: GestureDetector(
                                onTap: (){
                                  print("sad");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 2, 2, 5),
                                    child: Row( // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(Icons.star,
                                          color: Colors.black87,),
                                        Text(""" Add to \n favorites""",

                                          style: TextStyle(
                                            color: Colors.black87,
                                            letterSpacing: 1.0,
                                            fontWeight: FontWeight.bold
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

//            child: Row(
//              children: <Widget>[
//                Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Column(
//                     children: <Widget>[
//                       Text("meka thama text eka",
//                         style: TextStyle(
//                           color: Colors.grey[400],
//                           fontSize: 20.0,
//                         ),),
//                       Text("meka thama text eka",
//                         style: TextStyle(
//                           color: Colors.grey[400],
//                           fontSize: 20.0,
//                         ),),
//                     ],
//                   ),
//                   IntrinsicWidth(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                           child: FlatButton(
//                             onPressed: () => {},
//                             color: Colors.blue[800],
////                         padding: EdgeInsets.fromLTRB(8,0,8,0),
//                             child: Row( // Replace with a Row for horizontal icon + text
//                               children: <Widget>[
//                                 Icon(Icons.visibility,
//                                 color: Colors.grey[200],),
//                                 Text("Add to Watched List",
//
//                                 style: TextStyle(
//                                   color: Colors.grey[200],
//                                 ),)
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                           child: FlatButton(
//                             onPressed: () => {},
//                             color: Colors.orange,
////                         padding: EdgeInsets.fromLTRB(8,0,8,0),
//                             child: Row( // Replace with a Row for horizontal icon + text
//                               children: <Widget>[
//                                 Icon(Icons.star),
//                                 Text("Add to favorites")
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//                ),
//              ],
//            ),


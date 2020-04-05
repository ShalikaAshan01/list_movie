import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:list_movie/utils/app_drawer.dart';
import 'package:list_movie/utils/loading_widget.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  List _list = List<int>.generate(100, (index) => index);
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      body: AppDrawer(
        pageName: PageName.favourite,
        title: "Favourite",
        child: _buildList(),
      ),
    );
  }

  ///This function will build the favourite list
  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ListView.builder(
        itemCount: _list.length,
          itemBuilder: (context,index)=>_favouriteItem(_list[index])),
    );
  }

  Widget _favouriteItem(int index) {
    final imageURL = "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQ1bDkDLq-_bteASakhnC1XYwlkErFuqcof7KMhFpRwVhCTh1Vo";
    final name = "Captain Marvel $index";
    final category1 = "Action";
    final category2 = "Science Fiction";
    final runtime = "2h 2min";
    final rating = "8.5";

    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final imageSize = width * 0.2;
    Color brokenColor = Colors.black54;

    var categoryColor = Colors.black54;
    var imdbColor = Colors.black38;
    if(Theme.of(context).brightness == Brightness.dark){
      categoryColor = Colors.white70;
      imdbColor = Colors.grey;
    }

    final nameStyle = textTheme.headline6.copyWith(fontWeight: FontWeight.bold);
    final categoryStyle = TextStyle(fontSize: width * 0.042,fontWeight: FontWeight.bold,color: categoryColor);
    final imdbStyle = TextStyle(fontSize: width * 0.036,fontWeight: FontWeight.bold,color: imdbColor);

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(index),
      onDismissed: (direction){
        if(direction == DismissDirection.endToStart){
          _deleteMovie(name, index);
        }
      },
      background: Container(
        decoration: BoxDecoration(
            color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete,color: Colors.white,),
            SizedBox(width: 5,),
            Text("Remove",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.right,),
            SizedBox(width: 20,)
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                // image
                Container(
                  height: imageSize,
                  width: imageSize,
                  child: CachedNetworkImage(
                    imageUrl: imageURL,
                    alignment: Alignment.center,
                    imageBuilder: (context, image) {
                      return Container(
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: image, fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => Container(
                      child: LoadingWidget(
                        size: 25,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                        child: Icon(
                          Icons.broken_image,
                          color: brokenColor,
                        )),
                  ),
                ),
                SizedBox(width: 15,),
                //Content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,style: nameStyle,),
                      SizedBox(height: 5,),
                      Text("$category1| $category2  $runtime",style: categoryStyle,),
                      SizedBox(height: 5,),
                      Text("IMDB $rating",style: imdbStyle,),
                    ],
                  ),
                )
              ],
            ),
          ),
          // buttons
          Positioned(
            bottom: 5,
            right: 5,
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.playlist_add,color: imdbColor,), onTap: () => _saveToWatchList(name,index),
                ),
                InkWell(
                  child: Icon(Icons.delete,color: imdbColor,), onTap: () => _deleteMovie(name,index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //this method will remove the item from favourite list
  void _deleteMovie(String name, int id){
    setState(() {
      _list.removeAt(id);
    });
    final snackBar = SnackBar(content: Row(
      children: <Widget>[
        Text('$name is removed from the favourite list'),
        Expanded(
          child: MaterialButton(
            onPressed: (){
              setState(() {
                _list.add(id);
              });
              _scaffoldGlobalKey.currentState.hideCurrentSnackBar();
            },
            child: Text("Undo",style: TextStyle(color: Colors.pinkAccent),),
          ),
        )
      ],
    ));
    _scaffoldGlobalKey.currentState.showSnackBar(snackBar);
  }

  _saveToWatchList(String name, int index) {}
}

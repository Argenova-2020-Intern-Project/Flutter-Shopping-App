import 'package:Intern/models/Item.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final bool isAuthor;
  final Item item;
  final Function delete;
  final Function update;
  final BuildContext context;
  String dateTxt;

  ItemTile(
      {@required this.context,
      this.isAuthor,
      this.item,
      this.update,
      this.delete});

  String getDate(Duration dr) {
    if (dr.inDays >= 365) {
      return "${(dr.inDays / 365).round()} " + 'years ago';
    } else if (dr.inDays >= 7) {
      return "${(dr.inDays / 7).round()} " + 'weeks ago';
    } else if (dr.inDays >= 1) {
      return "${dr.inDays} " + 'days ago';
    } else if (dr.inHours >= 1) {
      return "${dr.inHours} " + 'hours ago';
    } else if (dr.inMinutes >= 1) {
      return "${dr.inMinutes} " + 'minutes ago';
    } else if (dr.inSeconds >= 1) {
      return "${dr.inSeconds} " + 'seconds ago';
    } else {
      return 'now';
    }
  }

  Function onTapVert(int value) {
    switch (value) {
      case 0:
        update.call();
        break;
      case 1:
        delete.call();
        break;
      default:
        return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = item.date.toDate();
    Duration dr = DateTime.now().difference(dt);
    dateTxt = getDate(dr);
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 10,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            DecoratedBox(
              position: DecorationPosition.background,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text.rich(
                          TextSpan(
                            text: "${item.author.name}\n• ",
                            children: [
                              TextSpan(
                                  text: dateTxt,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black
                                  )
                              ),
                            ]
                          )
                        ),
                    ),
                    Spacer(),
                    isAuthor
                        ? PopupMenuButton(
                            elevation: 3.2,
                            icon: Icon(Icons.more_horiz),
                            onSelected: onTapVert,
                            itemBuilder: (context) => <PopupMenuItem<int>>[
                              PopupMenuItem<int>(child: Text('Edit'), value: 0),
                              PopupMenuItem<int>(
                                  child: Text('Remove'), value: 1),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(item.title, textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Montserrat', fontSize: 25)),
                      Image.network(item.img_url, height: 250),
                      Text(item.explanation, textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
                      Text('Category: ' + item.category, textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
                      Text('Location: ' + item.latitude.toString() + ', ' + item.longitude.toString(), textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Montserrat', fontSize: 15)),
                      Text(item.price + '₺', textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Montserrat', fontSize: 20)),
                    ]
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

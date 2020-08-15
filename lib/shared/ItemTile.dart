import 'package:Intern/models/Item.dart';
import 'package:Intern/views/user-profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ItemTile extends StatelessWidget {
  final bool isAuthor;
  final Item item;
  final Function delete;
  final Function update;
  final BuildContext context;
  String dateTxt;

  ItemTile({@required this.context, this.isAuthor, this.item, this.update, this.delete});

  String getDate(Duration dr) {
    if (dr.inDays >= 365) {
      // 1 yıl önce
      return "${(dr.inDays / 365).round()} " + 'years_ago';
    } else if (dr.inDays >= 7) {
      // 1 hafta önce
      return "${(dr.inDays / 7).round()} " + 'weeks_ago';
    } else if (dr.inDays >= 1) {
      // 1 gün önce
      return "${dr.inDays} " + 'days_ago';
    } else if (dr.inHours >= 1) {
      // 1 saat önce
      return "${dr.inHours} " + 'hours_ago';
    } else if (dr.inMinutes >= 1) {
      return "${dr.inMinutes} " + 'minutes_ago';
    } else if (dr.inSeconds >= 1) {
      // saniye önce
      return "${dr.inSeconds} " + 'seconds_ago';
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
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            DecoratedBox(
              position: DecorationPosition.background,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, UserProfile.route_id,
                              arguments: UserProfile(
                                isAuthor: isAuthor,
                                user: item.author,
                              ));
                        },
                        child: Text.rich(
                            TextSpan(text: "${item.author.name}\n• ", children: [
                          TextSpan(
                              text: dateTxt,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white60)),
                        ])),
                      ),
                    ),
                    Spacer(),
                    isAuthor
                        ? PopupMenuButton(
                            elevation: 3.2,
                            icon: Icon(Icons.more_horiz),
                            tooltip: 'more',
                            onSelected: onTapVert,
                            itemBuilder: (context) => <PopupMenuItem<int>>[
                              PopupMenuItem<int>(
                                  child: Text('edit'), value: 0),
                              PopupMenuItem<int>(
                                  child: Text('remove'), value: 1),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Text(item.title, textAlign: TextAlign.center),
            ),
          ],
        ));
  }
}

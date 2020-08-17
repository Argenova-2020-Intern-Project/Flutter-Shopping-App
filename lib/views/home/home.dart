import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/Item.dart';
import 'package:Intern/services/authenticator.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/shared/CustomDialogs.dart';
import 'package:Intern/shared/ItemTile.dart';
import 'package:Intern/services/item-validator.dart';
import 'package:toast/toast.dart';
import 'package:Intern/views/home/item-list.dart';

class HomePage extends StatefulWidget {
  static const String route_id = "/home";

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with ItemValidationMixin {
  final formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController itemCtrl = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  List<Item> itemList = List();
  FirebaseUser user;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final int maxItemFromScreen = 10;
  
  Future getItems() async {
    user ??= await AuthService().getCurrentUser();
    return databaseService.items(limit: 5, isFirst: true);
  }

  Future onDeleteItem(Item item) async {
    var result = await databaseService.deleteItem(item);
    if (result == null) {
      Toast.show('There is something wrong about deleting your item', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
    } else {
      setState(() {
        itemList.remove(item);
        FocusScope.of(context).unfocus();
        Toast.show('Your item successfully deleted', context,
            duration: Toast.LENGTH_LONG,
            backgroundColor: ThemeData.dark().dialogBackgroundColor);
      });
    }
  }

  Future onUpdateItem(Item item) async {
    var result = await databaseService.updateItem(item);
    if (result == null) {
      Toast.show('There is something wrong about updating your item', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
    } else {
      setState(() {
        Toast.show('Your item successfully updated', context,
            duration: Toast.LENGTH_LONG,
            backgroundColor: ThemeData.dark().dialogBackgroundColor);
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    itemCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    super.initState();
  }

  void getMoreData() async {
    var newList =
        await databaseService.items(limit: maxItemFromScreen, isFirst: false);
    setState(() {
      itemList.addAll(newList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        key: refreshKey,
        backgroundColor: ThemeData.dark().primaryColor,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: FutureBuilder(
                    future: getItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                        );
                      } else {
                        itemList = snapshot.data;
                        return ItemList(user: user, itemList: itemList);
                        //return buildPostList();
                      }
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget buildItemList() {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: false,
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return ItemTile(
          isAuthor: user.uid == itemList[index].author.uid,
          item: itemList[index],
          delete: () => onDeleteItem(itemList[index]),
          update: () => CustomDialogs().updateItemDialog(
              context: context,
              item: itemList[index],
              onSubmitDialog: (newItem) {
                onUpdateItem(newItem);
                return null;
              }),
        );
      },
    );
  }

}

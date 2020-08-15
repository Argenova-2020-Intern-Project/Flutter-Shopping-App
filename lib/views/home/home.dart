import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      
      Toast.show('fail_process', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
      
    } else {
      setState(() {
        itemList.remove(item);
        FocusScope.of(context).unfocus();
        
        Toast.show('delete_success', context,
            duration: Toast.LENGTH_LONG,
            backgroundColor: ThemeData.dark().dialogBackgroundColor);
        
      });
    }
  }

  Future onUpdateItem(Item item) async {
    var result = await databaseService.updateItem(item);
    if (result == null) {
      
      Toast.show('fail_process', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
      
    } else {
      
      setState(() {
        Toast.show('update_success', context,
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
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'),
        actions: [
          IconButton(
            onPressed: () => authService.signOut(),
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
          )
        ],
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
                buildShareWidget(),
                DividerTheme(
                  data: ThemeData.dark().dividerTheme,
                  child: Divider(
                    height: 30,
                  ),
                ),
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

  Widget buildShareWidget() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  validator: validateItem,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'share_placeholder',
                  ),
                  controller: itemCtrl,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  String content = itemCtrl.text;
                  itemCtrl.clear();
                  user ??= await AuthService().getCurrentUser();
                  Item item = Item(
                      title: content,
                      author_id: user.uid,
                      date: Timestamp.now());
                  databaseService.insertItem(item).then((value) {
                    Toast.show('item_share_sucess', context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    setState(() {
                      itemList.add(item);
                    });
                  });
                }
                FocusScope.of(context).unfocus();
              },
              child: Text('share'),
            )
          ],
        ),
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

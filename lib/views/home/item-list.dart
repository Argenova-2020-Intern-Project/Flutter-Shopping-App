import 'package:firebase_auth/firebase_auth.dart';
import 'package:Intern/models/Item.dart';
import 'package:Intern/services/database.dart';
import 'package:Intern/shared/CustomDialogs.dart';
import 'package:Intern/shared/ItemTile.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ItemList extends StatefulWidget {
  final List<Item> itemList;
  final FirebaseUser user;

  ItemList({this.itemList, this.user});

  @override
  State createState() => _ItemList();
}

class _ItemList extends State<ItemList> {
  DatabaseService databaseService = DatabaseService();
  ScrollController scrollController = ScrollController();
  final int maxItemFromScreen = 10;

  Future onDeleteItem(Item item) async {
    var result = await databaseService.deleteItem(item);
    if (result == null) {
      Toast.show('fail_process', context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: ThemeData.dark().dialogBackgroundColor);
    } else {
      setState(() {
        widget.itemList.remove(item);
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

  void getMoreData() async {
    var newList =
        await databaseService.items(limit: maxItemFromScreen, isFirst: false);
    if (newList.length > 0) {
      widget.itemList.addAll(newList);
      setState(() {});
    }
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: false,
      itemCount: widget.itemList.length,
      itemBuilder: (context, index) {
        return ItemTile(
          context: context,
          isAuthor: widget.user.uid == widget.itemList[index].author.uid,
          item: widget.itemList[index],
          delete: () => onDeleteItem(widget.itemList[index]),
          update: () => CustomDialogs().updateItemDialog(
              context: context,
              item: widget.itemList[index],
              onSubmitDialog: (newItem) {
                onUpdateItem(newItem);
                return null;
              }),
        );
      },
    );
  }
}

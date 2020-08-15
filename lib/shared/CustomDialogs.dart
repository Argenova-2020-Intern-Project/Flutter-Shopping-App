import 'package:Intern/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CustomDialogs {

  void updateItemDialog({BuildContext context, Item item, Function onSubmitDialog(Item item)}) {
    TextEditingController updateItemCrtl = TextEditingController();
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Yazıyı Güncelle"),
        content: TextField(
          controller: updateItemCrtl..text = item.title,
          decoration: InputDecoration(
              hintText: "Bir söz yazın..."
          ),
        ),
        elevation: 5,
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              if (updateItemCrtl.text
                  .trim()
                  .length > 1000) {
                Toast.show("Sözünüz 1000 karakterden büyük olamaz", context,
                    gravity: Toast.CENTER);
              } else if (updateItemCrtl.text
                  .trim()
                  .isEmpty) {
                Toast.show("Lütfen geçerli bir söz giriniz.", context,
                    gravity: Toast.CENTER);
              } else {
                item.title = updateItemCrtl.text;
                updateItemCrtl.dispose();
                Navigator.pop(context);
                onSubmitDialog.call(item);
              }
            },
            child: Text("Gönder"),
          ),
        ],
      );
    },);
  }
}
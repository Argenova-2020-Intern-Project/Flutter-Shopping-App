import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Intern/models/Message.dart';
import 'package:Intern/models/User.dart';
import 'package:Intern/services/authenticator.dart';

class DatabaseService {
  final CollectionReference userCollRef =
      Firestore.instance.collection('users');
  final CollectionReference chatCollRef =
      Firestore.instance.collection('chats');
  final AuthService authService = AuthService();

  DocumentSnapshot lastUserDc;

  Future updateUser(User user) async {
    return await userCollRef.document(user.uid).setData({
        'uid': user.uid,
        'name': user.name,
        'email': user.email,
        'password': user.password,
    });
  }

  Future<User> getSpesificUser(String uid) async {
    DocumentSnapshot dc = await userCollRef.document(uid).get();
    return User(
      uid: dc.documentID,
      name: dc.data['name'],
      password: dc.data['password'],
      email: dc.data['email']
    );
  }

  Future<List<User>> users({int limit, bool isFirst}) async {
    List<User> userList = List();
    QuerySnapshot querySnapshot;
    if (isFirst || lastUserDc == null)
      querySnapshot = await userCollRef
          .orderBy('name', descending: false)
          .limit(limit)
          .getDocuments();
    else
      querySnapshot = await userCollRef
          .orderBy('name', descending: false)
          .startAfterDocument(lastUserDc)
          .getDocuments();

    for (var dc in querySnapshot.documents) {
      userList.add(
        User(
          uid: dc.documentID,
          name: dc.data['name'],
          email: dc.data['email'],
          password: dc.data['password']
        )
      );
      lastUserDc = dc;
    }
    return userList;
  }

  Future<List<User>> searchUser(String key) async {
    List<User> userList = List();

    QuerySnapshot querySnapshot =
        await userCollRef.orderBy('name', descending: false).getDocuments();

    for (var dc in querySnapshot.documents.where((element) =>
        element.data.toString().toLowerCase().contains(key.toLowerCase()))) {
      userList.add(
        User(
          uid: dc.documentID,
          name: dc.data['name'],
          email: dc.data['email'],
          password: dc.data['password']
        )
      );
    }
    return userList;
  }

  List<Message> _messageListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((e) {
      return Message(
          uid: e.data['uid'],
          senderId: e.data['senderId'],
          content: e.data['content'],
          time: e.data['time']);
    }).toList();
  }

  Stream<List<Message>> messages(String chatId) {
    return chatCollRef
        .document(chatId)
        .collection(chatId)
        .orderBy('time', descending: false)
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  Future insertMessage(Message message, String chatId) async {
    return await chatCollRef.document(chatId).collection(chatId).add({
      'senderId': message.senderId,
      'content': message.content,
      'time': message.time
    });
  }

  Future deleteMessages(String chatId) async {
    QuerySnapshot querySnapshot =
        await chatCollRef.document(chatId).collection(chatId).getDocuments();

    for (var dc in querySnapshot.documents) {
      dc.reference.delete();
    }
  }
}

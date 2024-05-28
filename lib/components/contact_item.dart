import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatefulWidget {
  final String contactId;
  const ContactItem({super.key, required this.contactId});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.contactId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LinearProgressIndicator(),
          );
        }
        return ListTile(
          title: Text(snapshot.data?['name']),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data?['photoUrl']),
          ),
        );
      },
    );
  }
}

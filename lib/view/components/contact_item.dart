import 'package:chat/core/controller/chat_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/utils/show_user_image.dart';
import 'package:chat/view/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactItem extends StatefulWidget {
  final String contactId;
  final String chatId;
  const ContactItem({super.key, required this.contactId, required this.chatId});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  final lastMessage = '';

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final chatController = Provider.of<ChatController>(context);

    return FutureBuilder(
      future: userController.getUserById(widget.contactId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: LinearProgressIndicator(),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              'Erro ao carregar contato: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        final user = snapshot.data!;
        return StreamBuilder(
          stream: chatController.getLastMessage(widget.chatId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListTile(
                key: const Key('contact_item'),
                title: Text(user.name),
                leading: showUserImg(user.imageUrl),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        chatId: widget.chatId,
                        name: user.name,
                      ),
                    )),
              );
            }
            late final String lastMessage;
            late final String lastMessageDate;
            if (snapshot.data != null && snapshot.hasData) {
              DateTime now = DateTime.now();

              if (snapshot.data!.createdAt.day == now.day &&
                  snapshot.data!.createdAt.month == now.month &&
                  snapshot.data!.createdAt.year == now.year) {
                lastMessageDate =
                    '${snapshot.data!.createdAt.hour.toString().padLeft(2, '0')}:${snapshot.data!.createdAt.minute.toString().padLeft(2, '0')}';
              } else {
                lastMessageDate =
                    '${snapshot.data!.createdAt.day}/${snapshot.data!.createdAt.month}/${snapshot.data!.createdAt.year}';
              }

              if (snapshot.data?.userId == widget.contactId) {
                lastMessage = snapshot.data!.text;
              } else {
                lastMessage = 'Você: ${snapshot.data!.text}';
              }
            }

            return ListTile(
              key: const Key('contact_item'),
              title: Row(
                children: [Text(user.name), Spacer(), Text(lastMessageDate)],
              ),
              enableFeedback: true,
              subtitle: Text(
                lastMessage,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              leading: showUserImg(user.imageUrl),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      chatId: widget.chatId,
                      name: user.name,
                    ),
                  )),
            );
          },
        );
      },
    );
  }
}

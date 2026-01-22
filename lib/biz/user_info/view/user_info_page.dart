import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gallery_next/base/widget/base/auto_load_widget.dart';
import 'package:flutter_gallery_next/base/widget/base/base_stateful_page.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/user_info_service.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/user_info_view_model.dart';
import 'package:get/get.dart';

class UserInfoPage extends BaseStatefulPage {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  BaseState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends BaseState<UserInfoViewModel, UserInfoPage> {
  @override
  String titleString() {
    return "AWS User List";
  }

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => UserInfoViewModel());
    Get.lazyPut(() => UserInfoService());
  }

  @override
  void dispose() {
    Get.delete<UserInfoViewModel>();
    Get.delete<UserInfoService>();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => viewMode.fetchFromAws(),
                    icon: const Icon(Icons.cloud_download),
                    label: const Text("Fetch from AWS API"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => viewMode.deleteAll(),
                    icon: const Icon(Icons.delete),
                    label: const Text("Clean Local DB"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AutoLoadWidget<List<UserInfoEntity>, UserInfoViewModel>(
              viewMode: viewMode,
              rxResponse: viewMode.userInfoState.rxUserList,
              autoEmpty: true,
              onEmpty: const Center(child: Text("No users found.")),
              widget: (list) {
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = list[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(user.id?.toString() ?? "?")),
                      title: Text(user.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Age: ${user.age}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showUserDialog(user: user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmDialog(user),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog for deleting a [user].
  void _showDeleteConfirmDialog(UserInfoEntity user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${user.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              viewMode.deleteUser(user.id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for adding a new user or editing an existing [user].
  ///
  /// If [user] is provided, the dialog fields are pre-filled with the user's information.
  void _showUserDialog({UserInfoEntity? user}) {
    final nameController = TextEditingController(text: user?.name ?? "");
    final ageController = TextEditingController(text: user?.age ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? "Add User" : "Update User"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person)),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age", prefixIcon: Icon(Icons.cake)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) return;

                final targetUser = user ?? UserInfoEntity();
                targetUser.name = nameController.text;
                targetUser.age = ageController.text;
                targetUser.email = user?.email ?? "N/A"; // Keeping original or N/A as requested to remove from UI
                targetUser.address = user?.address ?? "Default Address";
                targetUser.phone = user?.phone ?? "000-0000";

                viewMode.addOrUpdateUser(targetUser);
                Navigator.pop(context);
              },
              child: Text(user == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }
}

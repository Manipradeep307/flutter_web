import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'image_controller.dart';
import 'full_screen.dart';

class HomeScreen extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.closeMenu,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(
            children: [
              // Display Image using Obx() (Reactive State)
              Obx(() {
                if (controller.imageUrl.value == null) {
                  return const Spacer();
                }
                return Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        controller.imageUrl.value!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Failed to load image'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),

              if (controller.imageUrl.value == null) const Spacer(),

              // Input field and button to load image
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: urlController,
                      decoration: const InputDecoration(hintText: 'Image URL'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (urlController.text.isNotEmpty) {
                        controller.loadImage(urlController.text);
                        urlController.clear();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),

              if (controller.imageUrl.value != null) const SizedBox(height: 20),
              if (controller.imageUrl.value == null) const Spacer(),
            ],
          ),
        ),

        // Floating Action Button (Menu)
        floatingActionButton: Obx(() => Stack(
              children: [
                if (controller.isMenuOpen.value)
                  Positioned(
                    bottom: 100,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.extended(
                          heroTag: 'enter_fs',
                          label: const Text('Enter Fullscreen'),
                          onPressed: () {
                            if (controller.imageUrl.value != null) {
                              Get.to(() => FullScreenImage(
                                  imageUrl: controller.imageUrl.value!));
                              controller.closeMenu();
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.extended(
                          heroTag: 'exit_fs',
                          label: const Text('Exit Fullscreen'),
                          onPressed: controller.closeMenu,
                        ),
                      ],
                    ),
                  ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: controller.toggleMenu,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

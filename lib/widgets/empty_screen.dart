import 'package:flutter/material.dart';
import 'package:shop/inner_screens/feeds_screen.dart';
import 'package:shop/services/global_methods.dart';
import 'package:shop/services/utils.dart';
import 'package:shop/widgets/text_widget.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final themeState = Utils(context).getTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                text: 'Whoops!',
                color: Colors.red,
                textSize: 30,
                isTitle: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: title,
                color: Colors.cyan,
                textSize: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: subtitle,
                color: Colors.cyan,
                textSize: 20,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeState
                      ? const Color.fromARGB(255, 42, 66, 69)
                      : const Color.fromARGB(255, 89, 176, 188),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(4.0),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  GlobalMethods.navigateTo(
                    ctx: context,
                    routeName: FeedsScreen.routeName,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 46,
                    vertical: 20,
                  ),
                  child: TextWidget(
                    text: buttonText,
                    color: themeState
                        ? Colors.grey.shade300
                        : Colors.grey.shade800,
                    textSize: 20,
                    isTitle: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

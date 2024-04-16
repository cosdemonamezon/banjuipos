import 'package:flutter/material.dart';

class ItemMenuWidget extends StatelessWidget {
  const ItemMenuWidget({super.key, required this.pageActive, required this.image, required this.menu, required this.press, required this.title, required this.size});

  final String pageActive, menu, title, image;
  final VoidCallback press;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.14,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9),
        child: GestureDetector(
          onTap: press,
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: pageActive == menu ? Colors.blueAccent : Color.fromARGB(255, 68, 68, 68),
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.slowMiddle,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      image,
                      scale: 25,
                    ),
                    SizedBox(height: 5),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'IBMPlexSansThai',
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

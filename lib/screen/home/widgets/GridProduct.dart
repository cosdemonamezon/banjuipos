import 'package:banjuipos/models/product.dart';
import 'package:flutter/material.dart';

class GridProduct extends StatelessWidget {
  GridProduct({super.key, required this.products});

  Product products;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Image.network(
                products.image ?? 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                width: size.width * 0.22,
                height: size.height * 0.22,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: products.price != null
                      ? Text(
                          products.price!.toString(),
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansThai',
                          ),
                        )
                      : Text(
                          '0.00',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansThai',
                          ),
                        ),
                ),
              ),
              SizedBox(
                width: size.width * 0.18,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: size.height * 0.06,
                      width: double.maxFinite,
                      color: Color.fromARGB(60, 0, 0, 0),
                      child: Center(
                          child: products.name != null
                              ? Text(
                                  products.name!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'IBMPlexSansThai',
                                  ),
                                )
                              : Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'IBMPlexSansThai',
                                  ),
                                )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

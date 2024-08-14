import 'package:banjuipos/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridProduct extends StatelessWidget {
  GridProduct({super.key, required this.products});

  Product products;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.005),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  products.image != null
                      ? products.image!.pathUrl != null
                          ? CachedNetworkImage(
                              imageUrl: products.image!.pathUrl!,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: size.height * 0.24,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )
                          : Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                              width: size.width * 0.24,
                              height: size.height * 0.24,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) => Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                              ),
                            )
                      : Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                          width: size.width * 0.24,
                          height: size.height * 0.24,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) => Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                          ),
                        ),
                  products.newWeighQty != null
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: products.newWeighQty != 0 ? EdgeInsets.all(4) : EdgeInsets.all(0),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                            child: products.newWeighQty != 0
                                ? Text(
                                    products.newWeighQty!.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansThai',
                                    ),
                                  )
                                : SizedBox(),
                          ),
                        )
                      : SizedBox(),
        
                  // SizedBox(
                  //   width: size.width * 0.18,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Container(
                  //         height: size.height * 0.06,
                  //         width: double.maxFinite,
                  //         color: Color.fromARGB(60, 0, 0, 0),
                  //         child: Center(
                  //             child: products.name != null
                  //                 ? Text(
                  //                     products.name!,
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontFamily: 'IBMPlexSansThai',
                  //                     ),
                  //                   )
                  //                 : Text(
                  //                     '',
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontFamily: 'IBMPlexSansThai',
                  //                     ),
                  //                   )),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01,),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text('${products.name!}'),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text('${products.price!} ฿'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

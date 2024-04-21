import 'package:banjuipos/models/orderitems.dart';
import 'package:banjuipos/models/selectproduct.dart';
import 'package:flutter/material.dart';

const kButtonColor = Color(0xFF1264E3);
const kTabColor = Color(0xFF607D8B);
const ktextColr = Color(0xFF455A64);
const kTextButtonColor = Color.fromARGB(255, 255, 255, 255);
const kSecondaryColor = Color.fromARGB(255, 81, 120, 136);
const kButtoncolor = Color(0xFFFC7716);
const kTextDateColor = Color(0xffFA5A0E);

const String publicUrl = 'lim-kob-kun.dev-asha.com';

int sumQty(List<String> value) => value.fold(0, (p, o) => p + int.parse(o));
int sumNewQty(List<SelectProduct> value) => value.fold(0, (p, o) => p + o.newQty);
double sum(List<SelectProduct> orders) => orders.fold(0, (previous, o) => previous + (o.qty * o.product.price!));
double sumTotal(List<SelectProduct> orders) => orders.fold(0, (previous, o) => previous + ((o.qty - o.newQty) * o.product.price!));
double sumOneRow(SelectProduct value) => ((value.qty - value.newQty) * value.product.price!);
double sumOneRowReprint(OrderItems value) => ((value.quantity - value.dequantity) * value.price);
double sumOneColumn(List<SelectProduct> value) => value.fold(0, (previousValue, element) => previousValue + ((element.qty - element.newQty) * element.product.price!));
double sumNewOneColumn(List<OrderItems> value) => value.fold(0, (previousValue, element) => previousValue + ((element.quantity - element.dequantity) * element.product!.price!));


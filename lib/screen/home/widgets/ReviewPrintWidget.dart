import 'package:banjuipos/constants.dart';
import 'package:banjuipos/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewPrintWidget extends StatelessWidget {
  const ReviewPrintWidget({
    super.key,
    required this.orientation,
    required this.size,
    required this.globalKey,
    required this.order,
    required this.format,
    required this.oCcy,
  });

  final Orientation orientation;
  final Size size;
  final GlobalKey<State<StatefulWidget>> globalKey;
  final Order? order;
  final DateFormat format;
  final NumberFormat oCcy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: orientation == Orientation.portrait ? size.width * 0.43 : size.width * 0.36,
      child: RepaintBoundary(
        key: globalKey,
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ใบรับซื้อ',
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('------------------------------------------------------------------------------'),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'เลขที่เอกสาร',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'พนักงาน',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       'วันที่ออกเอกสาร',
                          //       style: TextStyle(fontSize: 20),
                          //     ),
                          //   ],
                          // ),
                        ],
                      )),
                  Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${order!.orderNo}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${order!.user?.firstName ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       '${format.format(order!.orderDate!)}',
                          //       style: TextStyle(fontSize: 20),
                          //     ),
                          //   ],
                          // ),
                        ],
                      )),
                ],
              ),
              Row(
                children: [
                  Text(
                    'ข้อมูลลูกค้า :',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ผู้ติดต่อ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'เบอร์ผู้ติดต่อ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'รหัสลูกค้า',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'ทะเบียนรถ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'ประเภทลูกค้า',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'คะแนน',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'วันที่ปริ๊นใบเสร็จ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    )),
                Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${order!.customer?.name ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${order!.customer?.phoneNumber ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${order!.customer?.code ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${order!.licensePlate ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${order?.customer?.level?.name ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${order!.customer?.point_balance ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${format.format(order!.orderDate!.add(Duration(hours: 7)))}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       '${format.format(dateTime)}',
                        //       style: TextStyle(fontSize: 20),
                        //     ),
                        //   ],
                        // ),
                      ],
                    )),
              ]),
              Row(
                children: [
                  Text('------------------------------------------------------------------------------'),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'รายการ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'จำนวน',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'ราคา',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'ราคารวม',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
              Row(
                children: [
                  Text('------------------------------------------------------------------------------'),
                ],
              ),
              order != null
                  ? order!.orderItems!.isNotEmpty
                      ? Column(
                          children: List.generate(
                            order!.orderItems!.length,
                            (index) => Row(
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${order!.orderItems![index].product?.name ?? ''}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${order!.orderItems![index].uptext ?? '-'}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'ลบ  ${order!.orderItems![index].downtext ?? '-'}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'จำนวนหลังหักลบ',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${order!.orderItems![index].quantity!.toStringAsFixed(1)}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${order!.orderItems![index].dequantity!.toStringAsFixed(1)}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${negative_result(order!.orderItems![index].quantity!, order!.orderItems![index].dequantity!).toStringAsFixed(1)}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${order!.orderItems![index].price}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        
                                      ],
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 20),
                                            )
                                            // order!.orderItems![index].dequantity != 0.0
                                            //     ? Text(
                                            //         '',
                                            //         style: TextStyle(fontSize: 20),
                                            //       )
                                            //     : Text(
                                            //         '${sumOneRowPrint(order!.orderItems![index]).toStringAsFixed(2)}',
                                            //         style: TextStyle(fontSize: 20),
                                            //       ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            order!.orderItems![index].dequantity != 0.0
                                                ? Text(
                                                    '${oCcy.format(roundDownToDecimalPlaces(sumOneRowReprint(order!.orderItems![index]), 0))}',
                                                    style: TextStyle(fontSize: 20),
                                                  )
                                                : Text(
                                                    '${oCcy.format(roundDownToDecimalPlaces(sumOneRowPrint(order!.orderItems![index]), 0))}',
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        )
                      : SizedBox()
                  : SizedBox(),
              Row(
                children: [
                  Text('------------------------------------------------------------------------------'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ยอดสุทธิ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${oCcy.format(sumNewOneColumn(order!.orderItems!))} ฿',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('------------------------------------------------------------------------------'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ประเภทการชำระ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${order!.paymentMethod?.name ?? ''}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              order != null
                  ? order!.accountName != null && order!.accountName != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ชื่อบัญชี',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${order!.accountName ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      : SizedBox()
                  : SizedBox(),
              order != null
                  ? order!.accountNumber != null && order!.accountNumber != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'เลขที่บัญชี',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${order!.accountNumber ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      : SizedBox()
                  : SizedBox(),
              order != null
                  ? order!.bankName != null && order!.bankName != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ธนาคาร',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${order?.bankName ?? ''}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )
                      : SizedBox()
                  : SizedBox(),
              Row(
                children: [
                  Text('------------------------------------------------------------------------------'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:banjuipos/constants.dart';
import 'package:banjuipos/screen/home/printPreview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPrintWidget extends StatelessWidget {
  const ViewPrintWidget({
    super.key,
    required this.orientation,
    required this.size,
    required this.globalKey,
    required this.widget,
    required this.format,
    required this.oCcy,
  });

  final Orientation orientation;
  final Size size;
  final GlobalKey<State<StatefulWidget>> globalKey;
  final PrintPreview widget;
  final DateFormat format;
  final NumberFormat oCcy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: orientation == Orientation.portrait ? size.width * 0.43 : size.width * 0.33,
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
                  Text('-----------------------------------------------------------------------'),
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
                        ],
                      )),
                  Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.order.orderNo}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.order.user?.firstName ?? ''}',
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
                  Text(
                    'ข้อมูลลูกค้า :',
                    style: TextStyle(fontSize: 20),
                  ),
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
                                '${widget.order.customer?.name ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.order.customer?.phoneNumber ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.order.customer?.code ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.order.licensePlate ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.order.customer?.level?.name ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.order.customer?.point_balance ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${format.format(widget.order.orderDate!.add(Duration(hours: 7)))}',
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
                  Text('-----------------------------------------------------------------------'),
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
                  Text('-----------------------------------------------------------------------'),
                ],
              ),
              widget.order != null
                  ? widget.order.orderItems!.isNotEmpty
                      ? Column(
                          children: List.generate(
                            widget.order.orderItems!.length,
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
                                              '${widget.order.orderItems![index].product?.name ?? ''} :',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${widget.order.orderItems![index].uptext ?? '-'}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'ลบ  ${widget.order.orderItems![index].downtext ?? '-'}',
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
                                              '${widget.order.orderItems![index].quantity!.toStringAsFixed(1)}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${widget.order.orderItems![index].dequantity!.toStringAsFixed(1)}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${negative_result(widget.order.orderItems![index].quantity!, widget.order.orderItems![index].dequantity!).toStringAsFixed(1)}',
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
                                              '${widget.order.orderItems![index].price!.toStringAsFixed(2)}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            // Text(
                                            //   '${widget.order.orderItems![index].price!.floor().toStringAsFixed(2)}',
                                            //   style: TextStyle(fontSize: 20),
                                            // ),
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
                                            // widget.order.orderItems![index].dequantity != 0.0
                                            //     ? Text(
                                            //         '',
                                            //         style: TextStyle(fontSize: 20),
                                            //       )
                                            //     : Text(
                                            //         '${sumOneRowPrint(widget.order.orderItems![index]).floor().toStringAsFixed(2)}',
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
                                            widget.order.orderItems![index].dequantity != 0.0
                                                ? Text(
                                                    '${oCcy.format(sumOneRowReprint(widget.order.orderItems![index]))}',
                                                    style: TextStyle(fontSize: 20),
                                                  )
                                                : Text(
                                                    '${oCcy.format(sumOneRowPrint(widget.order.orderItems![index]))}',
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
                  Text('-----------------------------------------------------------------------'),
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
                    '${oCcy.format(sumNewOneColumn(widget.order.orderItems!))} ฿',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('-----------------------------------------------------------------------'),
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
                    '${widget.order.paymentMethod?.name ?? ''}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              widget.order.accountName != null && widget.order.accountName != ""
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ชื่อบัญชี',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${widget.order.accountName ?? ''}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  : SizedBox(),
              widget.order.accountNumber != null && widget.order.accountNumber != ""
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'เลขที่บัญชี',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${widget.order.accountNumber ?? ''}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  : SizedBox(),
              widget.order.bankName != null && widget.order.bankName != ""
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ธนาคาร',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${widget.order.bankName ?? ''}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  : SizedBox(),
              Row(
                children: [
                  Text('-----------------------------------------------------------------------'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

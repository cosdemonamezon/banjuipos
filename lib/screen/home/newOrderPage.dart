import 'package:banjuipos/constants.dart';
import 'package:banjuipos/extension/formattedMessage.dart';
import 'package:banjuipos/screen/home/rePrintOrder.dart';
import 'package:banjuipos/screen/home/services/productController.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:banjuipos/widgets/LoadingDialog.dart';
import 'package:banjuipos/widgets/dateSelected.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  DateFormat formatter2 = DateFormat('yyyy-MM-dd');
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  List<int> perPage = [10, 20, 50, 100];
  int selectedPage = 10;
  int page = 1;
  DateTime? selectedDate;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  NumberPaginatorController numberController = NumberPaginatorController();
  String orderDate = "\$btw:${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00,${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getlistOrderByDate(page: page, orderDate: orderDate);
    });
  }

  String getCurrentRouteOption(BuildContext context) {
    var isEmpty = ModalRoute.of(context) != null && ModalRoute.of(context)!.settings.arguments != null && ModalRoute.of(context)!.settings.arguments is String
        ? ModalRoute.of(context)!.settings.arguments as String
        : '';

    return isEmpty;
  }

  Future<void> getlistOrder({required int page, int? length = 10}) async {
    try {
      LoadingDialog.open(context);
      await context.read<ProductController>().getListOrder(start: page, length: length!);
      if (!mounted) return;
      LoadingDialog.close(context);
      // createDataSource();
    } on Exception catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  Future<void> getlistOrderByDate({required int page, int? length = 10, required String orderDate}) async {
    try {
      LoadingDialog.open(context);
      await context.read<ProductController>().getListOrderByDate(start: page, length: length!, orderDate: orderDate);
      if (!mounted) return;
      LoadingDialog.close(context);
      // createDataSource();
    } on Exception catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '${e.getMessage}',
          pressYes: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // กำหนดวันที่เริ่มต้นที่เลือกได้
      lastDate: DateTime(2100), // กำหนดวันที่สิ้นสุดที่เลือกได้
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<ProductController>(builder: (context, productController, child) {
      final orders = productController.myOrder;
      return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 15,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.01),
                    Container(
                      height: size.height * 0.12,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Color(0xFFECEFF1)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "รายการคำสั่งซื้อ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "วันที่เริ่มต้น",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: size.width * 0.18,
                                height: size.height * 0.07,
                                child: DateSelected(
                                  dateController: startDate,
                                  press: () async {
                                    final _date = await _selectDate(context);
                                    if (_date != null) {
                                      setState(() {
                                        startDate.text = formatter2.format(_date);
                                        //String formattedDate = DateFormat('dd-MM-yyyy').format(_date);
                                        //dateController.text = formattedDate.toString(); // Update the text field
                                        //widget.testTestDate.text = formattedDate.toString();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: size.width * 0.01),
                          Text('-'),
                          SizedBox(width: size.width * 0.01),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "วันที่สิ้นสุด",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: size.width * 0.18,
                                height: size.height * 0.07,
                                child: DateSelected(
                                  dateController: endDate,
                                  press: () async {
                                    final _date = await _selectDate(context);
                                    if (_date != null) {
                                      setState(() {
                                        endDate.text = formatter2.format(_date);
                                        //String formattedDate = DateFormat('dd-MM-yyyy').format(_date);
                                        //dateController.text = formattedDate.toString(); // Update the text field
                                        //widget.testTestDate.text = formattedDate.toString();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: size.width * 0.02),
                          GestureDetector(
                            onTap: () async {
                              if (startDate.text != '' && endDate.text != '') {
                                setState(() {
                                  orderDate = "\$btw:${startDate.text} 00:00:00,${endDate.text} 23:59:59";
                                  page = 1;
                                });
                                await numberController.navigateToPage(0);
                                getlistOrderByDate(page: page, orderDate: orderDate);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogYes(
                                    title: 'แจ้งเตือน',
                                    description: 'โปรดกำหนดวันที่เริ่มต้นและวันที่สิ้นสุด',
                                    pressYes: () {
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                              }
                            },
                            child: Card(
                              color: Colors.blue,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: SizedBox(
                                width: size.width * 0.15,
                                height: size.height * 0.06,
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: size.width * 0.005),
                                    Text(
                                      'ค้นหา',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.01),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                startDate.clear();
                                endDate.clear();
                                page = 1;
                                orderDate = "\$btw:${DateFormat('yyyy-MM-dd').format(DateTime.now())} 00:00:00,${DateFormat('yyyy-MM-dd').format(DateTime.now())} 23:59:59";
                              });
                              numberController.navigateToPage(0);
                              getlistOrderByDate(page: page, orderDate: orderDate);
                            },
                            child: Card(
                              color: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: SizedBox(
                                width: size.width * 0.15,
                                height: size.height * 0.06,
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: size.width * 0.005),
                                    Text(
                                      'ล้าง',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      width: double.infinity,
                      child: DataTable(
                        columns: [
                          DataColumn2(
                            label: Text('เลขใบเสร็จ'),
                            size: ColumnSize.S,
                            fixedWidth: getCurrentRouteOption(context) == fixedColumnWidth ? 200 : null,
                          ),
                          DataColumn2(
                            label: Text('วันที่'),
                            size: ColumnSize.S,
                            fixedWidth: getCurrentRouteOption(context) == fixedColumnWidth ? 200 : null,
                          ),
                          DataColumn2(
                            label: Text('ยอดสุทธิ(บาท)'),
                            size: ColumnSize.S,
                            fixedWidth: getCurrentRouteOption(context) == fixedColumnWidth ? 200 : null,
                          ),
                          DataColumn2(
                            label: Text('สถานะ'),
                            size: ColumnSize.S,
                            fixedWidth: getCurrentRouteOption(context) == fixedColumnWidth ? 200 : null,
                          ),
                          DataColumn2(
                            label: Text('ปริ๊นใบเสร็จ'),
                            size: ColumnSize.S,
                            fixedWidth: getCurrentRouteOption(context) == fixedColumnWidth ? 200 : null,
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          orders?.data?.length ?? 0,
                          (index) => DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                              }
                              if (index.isEven) {
                                return Colors.grey.withOpacity(0.1);
                              }
                              return null;
                            }),
                            cells: <DataCell>[
                              DataCell(Text(orders?.data?[index].orderNo?.toString() ?? "-")),
                              DataCell(Text(formatter.format(orders!.data![index].orderDate!))),
                              DataCell(Text(orders.data?[index].grandTotal?.toString() ?? "-")),
                              DataCell(Text('จ่ายแล้ว')),
                              DataCell(Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.015),
                                child: GestureDetector(
                                  onTap: () {
                                    //sentOrder(data[index]);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RePrintOrder(orderId: orders.data![index].id)));
                                  },
                                  child: Image.asset(
                                    'assets/icons/Printer.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    orders?.data?.isEmpty ?? true
                    ?Column(
                      children: [
                        SizedBox(height: size.height * 0.03),
                        Text('วันนี้ไม่พบรายการ', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
                    )
                    :SizedBox.shrink(),
                    orders?.data?.isEmpty ?? true
                        ? SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Container(
                              //   color: Color.fromARGB(255, 241, 241, 241),
                              //   width: size.width * 0.07,
                              //   height: size.height * 0.05,
                              //   child: Center(
                              //     child: DropdownButton<int>(
                              //       selectedItemBuilder: (e) => perPage.map<Widget>((item) {
                              //         return Padding(
                              //           padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                              //           child: Text(
                              //             item.toString(),
                              //             style: TextStyle(color: Colors.black, fontSize: 18),
                              //           ),
                              //         );
                              //       }).toList(),
                              //       isDense: true,
                              //       isExpanded: true,
                              //       icon: Icon(
                              //         Icons.arrow_drop_down,
                              //         color: Colors.black,
                              //         size: 30,
                              //       ),
                              //       underline: SizedBox(),
                              //       items: perPage.map<DropdownMenuItem<int>>((item) {
                              //         return DropdownMenuItem<int>(
                              //           value: item,
                              //           child: Text(
                              //             item.toString(),
                              //             style: TextStyle(
                              //               fontFamily: 'IBMPlexSansThai',
                              //               color: Colors.black,
                              //             ),
                              //           ),
                              //         );
                              //       }).toList(),
                              //       value: selectedPage,
                              //       onChanged: (v) async {
                              //         setState(() {
                              //           selectedPage = v!;
                              //         });
                              //         await getlistOrder(page: page, length: selectedPage);
                              //       },
                              //     ),
                              //   ),
                              // ),
                              SizedBox(width: size.width * 0.02),
                              Text('Previous'),
                              SizedBox(
                                width: size.width * 0.132,
                                child: NumberPaginator(
                                  numberPages: orders?.meta?.totalPages ?? 1,
                                  // prevButtonContent: Text('Previous'),
                                  // nextButtonContent: Text('Next'),
                                  controller: numberController,
                                  config: NumberPaginatorUIConfig(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mode: ContentDisplayMode.dropdown,
                                    height: 50,
                                    buttonShape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPageChange: (p0) async {
                                    //LoadingDialog.open(context);
                                    setState(() {
                                      page = p0 + 1;
                                    });
                                    await getlistOrderByDate(page: page, orderDate: orderDate);
                                    //await getlistOrder(page: p0 + 1);
                                    if (!mounted) {
                                      return;
                                    }
                                    //LoadingDialog.close(context);
                                  },
                                ),
                              ),
                              Text('Next'),
                              SizedBox(width: size.width * 0.01),
                            ],
                          ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

import 'package:banjuipos/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TableOrder extends StatefulWidget {
  TableOrder({super.key, required this.orders, required this.reciveOrder});
  List<Order> orders;
  Function(Order) reciveOrder;

  @override
  State<TableOrder> createState() => _TableOrderState();
}

class _TableOrderState extends State<TableOrder> {
  List<Order> orders = [];
  int _pageSize = 10;
  @override
  void initState() {
    super.initState();
    setState(() {
      orders = widget.orders;
    });
  }
  DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: Theme(
        // data: Theme.of(context).copyWith(
        //   cardColor: Colors.blue[100],
        //   dividerColor: Colors.white,
        // ),
        data: ThemeData(cardColor: Colors.white, textTheme: TextTheme(caption: TextStyle(color: Colors.black))),
        child: PaginatedDataTable(
          header: Text('รายการคำสั่งซื้อ'),
          rowsPerPage: _pageSize,
          onRowsPerPageChanged: (value) {
            setState(() {
              _pageSize = value!;
            });
          },
          columns: [
            DataColumn(label: Text('เลขใบเสร็จ')),
            DataColumn(label: Text('วันที่')),
            DataColumn(label: Text('ยอดสุทธิ(บาท)')),
            DataColumn(label: Text('สถานะ')),
            DataColumn(label: Text('รูปภาพ')),
          ],
          source: _DataSource(data: orders, sentOrder: (orderValue){
            widget.reciveOrder(orderValue);
            //inspect(orderValue);
          }),
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<Order> data;
  Function(Order) sentOrder;

  _DataSource({required this.data, required this.sentOrder});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    return DataRow(cells: [
      DataCell(Text(item.orderNo!)),
      DataCell(Text(formatter.format(item.orderDate!))),
      DataCell(Text(item.grandTotal.toString())),
      DataCell(Text(item.orderStatus!)),
      DataCell(GestureDetector(
        onTap: (){
          sentOrder(data[index]);
        },
        child: Image.asset(
          'assets/icons/Printer.png',
          width: 25,
          height: 25,
        ),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
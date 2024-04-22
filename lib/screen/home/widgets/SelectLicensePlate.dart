import 'package:banjuipos/models/licenseplates.dart';
import 'package:banjuipos/widgets/AlertDialogYesNo.dart';
import 'package:flutter/material.dart';

class SelectLicensePlate extends StatefulWidget {
  SelectLicensePlate({super.key, required this.licenseplates});
  List<LicensePlates> licenseplates;
  @override
  State<SelectLicensePlate> createState() => _SelectLicensePlateState();
}

class _SelectLicensePlateState extends State<SelectLicensePlate> {
  int? select;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
        title: Center(child: Text('เลือกทะเบียนรถ')),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
        content: Container(
          height: size.height * 0.4,
          width: size.width * 0.3,
          child: SingleChildScrollView(
            child: widget.licenseplates.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        height: size.height * 0.50,
                        child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.licenseplates.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  color: Color.fromARGB(255, 238, 234, 234),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 238, 231, 231),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white),
                                    //decoration: BoxDecoration(color: read ? Colors.white : Color.fromRGBO(0, 0, 0, 0.1), borderRadius: BorderRadius.circular(8)),
                                    child: ListTile(
                                      title: Text(
                                        '${widget.licenseplates[index].licensePlate}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      trailing: select == index
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            )
                                          : Icon(
                                              Icons.keyboard_arrow_right,
                                            ),
                                      onTap: () async {
                                        setState(() {
                                          select = index;
                                          if (widget.licenseplates[select!].select == true) {
                                            widget.licenseplates[select!].select = false;
                                          } else {
                                            widget.licenseplates[select!].select = true;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  )
                : SizedBox(),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                  //textColor: Color(0xFF6200EE),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  //textColor: Color(0xFF6200EE),
                  onPressed: () async {
                    if (select != null) {
                      Navigator.pop(context, widget.licenseplates[select!]);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialogYes(
                          title: 'แจ้งเตือน',
                          description: 'โปรดเลือกทะเบียนรถ 1 รายการ',
                          pressYes: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    }
                  },
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]);
  }
}

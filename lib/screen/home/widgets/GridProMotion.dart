import 'package:banjuipos/constants.dart';
import 'package:flutter/material.dart';


class GridProMotion extends StatefulWidget {
  const GridProMotion({super.key});

  @override
  State<GridProMotion> createState() => _GridProMotionState();
}

class _GridProMotionState extends State<GridProMotion> {
  final List<Map<String, dynamic>> GridProMotion = [
    {
      'image': 'assets/images/figure.png',
      'Tiltle': 'BUY 2 PAY 2  ฿ 165.00',
      'Order1': 'น้ำผึ้งมะนาวซุปเปอร์เวค',
      'Order2': 'อเมริการโน่น้ำผึ้งมะนาว'
    },
    {
      'image': 'assets/images/figure.png',
      'Tiltle': 'BUY 2 PAY 2  ฿ 165.00',
      'Order1': 'กาแฟสังขยา (Custard Coffee)',
      'Order2': 'สังขยาลาเต้ (Custrad Latte)'
    },
    {
      'image': 'assets/images/figure.png',
      'Tiltle': 'BUY 2 PAY 2  ฿ 165.00',
      'Order1': 'คาผูชิโน่ร้อน (Hot Capucino)',
      'Order2': 'ลาเต้ร้อน (Hot Latte)'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: Color(0xFF37474F)),
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisExtent: 85,
            ),
            itemCount: GridProMotion.length,
            itemBuilder: (_, index) {
              return Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          GridProMotion[index]['image'],
                          width: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: DashedVerticalLine(),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GridProMotion[index]['Tiltle'],
                          style: TextStyle(fontSize: 14, fontFamily: 'IBMPlexSansThai', fontWeight: FontWeight.bold),
                        ),
                        Text(
                          GridProMotion[index]['Order1'],
                          style: TextStyle(
                            fontSize: 10,
                            color: ktextColr,
                            fontFamily: 'IBMPlexSansThai',
                          ),
                        ),
                        Text(
                          GridProMotion[index]['Order2'],
                          style: TextStyle(
                            fontSize: 10,
                            color: ktextColr,
                            fontFamily: 'IBMPlexSansThai',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class DashedVerticalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5, // กว้างของเส้นประ
      height: 120, // ความสูงของเส้นประ
      child: CustomPaint(
        painter: DashedLinePainter(),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF90A4AE)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double dashWidth = 5;
    final double dashSpace = 5;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += (dashWidth + dashSpace);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

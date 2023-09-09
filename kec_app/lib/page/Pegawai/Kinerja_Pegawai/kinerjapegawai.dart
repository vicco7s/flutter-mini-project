import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';


class KinerjaPegawai extends StatefulWidget {
  const KinerjaPegawai({super.key});

  @override
  State<KinerjaPegawai> createState() => _KinerjaPegawaiState();
}

class _KinerjaPegawaiState extends State<KinerjaPegawai> {
  @override
  Widget build(BuildContext context) {
    return TravelChart();
  }
}

class TravelChart extends StatelessWidget {
  const TravelChart({super.key});

  Widget buttonTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 2:
        text = 'Feb';
        break;
      case 4:
        text = 'Mar';
        break;
      case 6:
        text = 'Apr';
        break;
      case 8:
        text = 'Mey';
        break;
      case 10:
        text = 'Jun';
        break;
      case 12:
        text = 'Jul';
        break;
      case 14:
        text = 'Aug';
        break;
      case 16:
        text = 'Sep';
        break;
      case 18:
        text = 'Okt';
        break;
      case 20:
        text = 'Nov';
        break;
      case 22:
        text = 'Des';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 2:
        text = '2';
        break;
      case 4:
        text = '4';
        break;
      case 6:
        text = '6';
        break;
      case 8:
        text = '8';
        break;
      case 10:
        text = '10';
        break;
      case 12:
        text = '12';
        break;
      case 14:
        text = '14';
        break;
      case 16:
        text = '16';
        break;
      case 18:
        text = '18';
        break;
      case 20:
        text = '20';
        break;
      case 22:
        text = '22';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Future<Map<String, List<FlSpot>>> fetchDataFromFirestore() async {
  Map<String, List<FlSpot>> employeeData = {};

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('pdinas').where("nama", isEqualTo: "Akhmad S.Sos., M.AP")
      .get();

  for (var doc in querySnapshot.docs) {
    String namaPegawai = doc['nama'];
    Timestamp tanggalTimestamp = doc['tanggal_mulai'];

    DateTime tanggal = tanggalTimestamp.toDate();
    
    // Check if the trip date falls within January to December
    if (tanggal.month >= 1 && tanggal.month <= 12) {
      // Initialize the list for the employee if not already done
      employeeData.putIfAbsent(namaPegawai, () => List.generate(12, (index) {
        // Adjust the X-coordinate based on the desired interval (e.g., 2)
        double adjustedXCoordinate = index.toDouble() * 2;
        return FlSpot(adjustedXCoordinate, 0);
      }));

      // Increment the count for the corresponding month and employee
      int monthIndex = tanggal.month - 1;
      if (monthIndex >= 0 && monthIndex < 12) {
        employeeData[namaPegawai]![monthIndex] = FlSpot(
          employeeData[namaPegawai]![monthIndex].x, // Keep the same X-coordinate
          employeeData[namaPegawai]![monthIndex].y + 1,
        );
      }
    }
  }

  return employeeData;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Kinerja Pegawai'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: 400,
            height:400,
            child: FutureBuilder<Map<String, List<FlSpot>>>(
              future: fetchDataFromFirestore(),
              builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ColorfulCirclePrgressIndicator();
              }else if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }else{
                List<LineChartBarData> lineBarsData = [];
                snapshot.data!.forEach((employeeName, employeeSpots) {
                  lineBarsData.add(
                    LineChartBarData(
                      spots: employeeSpots,
                      isCurved: false,
                      color: Colors.blueAccent[700], // Use a unique color for each employee
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: true),
                      barWidth: 2, // Adjust the bar width as needed
                      isStrokeCapRound: true,
                    ),
                  );
                });
              return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey.withOpacity(0.6),
                  ),
                ),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameSize: 12,
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: buttonTitleWidgets,
                      reservedSize: 28,
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameSize: 12,
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 28,
                      interval: 1,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    )
                  )
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xff37434d),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: 22,
                minY: 0,
                maxY: 20,
                lineBarsData: lineBarsData,
              ),
            );
                }
              },
            )
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';

class KinerjaPegawai extends StatefulWidget {
  final DocumentSnapshot documentsnapshot;
  const KinerjaPegawai({super.key, required this.documentsnapshot});

  @override
  State<KinerjaPegawai> createState() => _KinerjaPegawaiState();
}

class _KinerjaPegawaiState extends State<KinerjaPegawai> {
  int selectedYear = DateTime.now().year;
  List<int> availableYears = [2022, 2023, 2024, 2025, 2026, 2027];
  Widget buttonTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
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
      color: Colors.white,
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

  Future<Map<String, List<FlSpot>>> fetchDataFromFirestore(int year) async {
    Map<String, List<FlSpot>> employeeData = {};

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pdinas')
        .where("nama", isEqualTo: widget.documentsnapshot['nama'])
        .get();

    for (var doc in querySnapshot.docs) {
      String namaPegawai = doc['nama'];
      Timestamp tanggalTimestamp = doc['tanggal_mulai'];

      DateTime tanggal = tanggalTimestamp.toDate();

      // Check if the trip date falls within January to December
      if (tanggal.year == year) {
        // Initialize the list for the employee if not already done
        employeeData.putIfAbsent(
            namaPegawai,
            () => List.generate(12, (index) {
                  // Adjust the X-coordinate based on the desired interval (e.g., 2)
                  double adjustedXCoordinate = index.toDouble() * 2;
                  return FlSpot(adjustedXCoordinate, 0);
                }));

        // Increment the count for the corresponding month and employee
        int monthIndex = tanggal.month - 1;
        if (monthIndex >= 0 && monthIndex < 12) {
          employeeData[namaPegawai]![monthIndex] = FlSpot(
            employeeData[namaPegawai]![monthIndex]
                .x, // Keep the same X-coordinate
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        elevation: 0.0,
        title: Text("Kinerja Pegawai"),
        actions: [
          DropdownButton<int>(
            value: selectedYear,
            onChanged: (year) {
              setState(() {
                selectedYear = year!;
              });
            },
            items: availableYears.map<DropdownMenuItem<int>>((int year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString(), style: TextStyle(color: year == selectedYear ? Colors.blue : Colors.black,),),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,),
                        child: Text("Nama", style: TextStyle(color: Colors.white),)),
                      SizedBox(width: 10,),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green,),
                        child: Text(widget.documentsnapshot["nama"], style: TextStyle(color: Colors.white),)),
                    ],
                  ),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange,),
                        child: Text(widget.documentsnapshot["nip"], style: TextStyle(color: Colors.white),)),
                      SizedBox(width: 10,),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.pink,),
                        child: Text("Nip", style: TextStyle(color: Colors.white),))
                    ],
                  ),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purple,),
                        child: Text("Grafik Tahun", style: TextStyle(color: Colors.white),)),
                      SizedBox(width: 10,),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,),
                        child: Text(selectedYear.toString(), style: TextStyle(color: Colors.white),))
                    ],
                  ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.deepOrange,),
                        child: Text("Grafik Kinerja Pegawai", style: TextStyle(color: Colors.white),)),
                    ],
                  ),
                SizedBox(height: 10,),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green[800]
                  ),
                  width: 350,
                  height: 300,
                  child: FutureBuilder<Map<String, List<FlSpot>>>(
                    future: fetchDataFromFirestore(selectedYear),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ColorfulCirclePrgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<LineChartBarData> lineBarsData = [];
                        snapshot.data!.forEach((employeeName, employeeSpots) {
                          lineBarsData.add(
                            LineChartBarData(
                              spots: employeeSpots,
                              isCurved: false,
                              color: Colors.white, // Use a unique color for each employee
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
                                    reservedSize: 18,
                                    interval: 1,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  axisNameSize: 12,
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: leftTitleWidgets,
                                    reservedSize: 18,
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
                                ))),
                            borderData: FlBorderData(
                              show: true,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                )
                              )
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
                  )),
            ],
          ),
      ),
    );
  }
}

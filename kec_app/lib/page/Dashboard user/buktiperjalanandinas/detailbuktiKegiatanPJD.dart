import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kec_app/controller/controllerPerjalananDinas/controllerBuktiKegiatanPJD.dart';
import 'package:kec_app/util/controlleranimasiloading/CircularControlAnimasiProgress.dart';

import 'editBuktiKegiantanPJD.dart';

class DetailBuktiKegiatanPJD extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetailBuktiKegiatanPJD({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);

    Timestamp timerstamp = documentSnapshot['tgl_awal'];
    var date = timerstamp.toDate();
    var tanggal_awal = DateFormat('dd', 'id').format(date);

    Timestamp timerstamps = documentSnapshot['tgl_akhir'];
    var dates = timerstamps.toDate();
    var tanggal_akhir = DateFormat.yMMMMd('id').format(dates);

    final dataBuktiKegiatan = ControllerBuktiKegiatanPJD();
    final List<dynamic> imageUrls = documentSnapshot['imageUrl'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ColorfulCirclePrgressIndicator();
            } else {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 400,
                          child: CarouselSlider.builder(
                            unlimitedMode: true,
                            enableAutoSlider: true,
                            itemCount: imageUrls.length,
                            slideIndicator: CircularSlideIndicator(
                              currentIndicatorColor: Color(0xfffc16ffc),
                              padding: EdgeInsets.only(bottom: 32),
                              indicatorBorderColor: Colors.white,
                            ),
                            slideTransform: ZoomOutSlideTransform(),
                            autoSliderTransitionTime:
                                Duration(milliseconds: 600),
                            slideBuilder: (index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 0.0),
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15.0),
                                          bottomRight: Radius.circular(15.0)),
                                      child: Image.network(
                                        imageUrls[index],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.error),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          indent: 100,
                          endIndent: 100,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Dasar",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Card(
                            elevation: 1.0,
                            color: Color(0xfffc16ffc),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: ListTile(
                              title: Text(
                                documentSnapshot['dasar'],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Hasil Bukti Perjalanan Dinas",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Card(
                            elevation: 1.0,
                            color: Color(0xfffc16ffc),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: ListTile(
                              title: Text(
                                documentSnapshot['hasil'],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(65, 0, 0, 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25,
                    right: 0,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(65, 0, 0, 0),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => EditButkiKegiantanPjd(documentSnapshot: documentSnapshot,)));
                        },
                      ),
                    ),
                  ),
                  
                ],
              );
            }
          },
        )
    );
  }
  
}


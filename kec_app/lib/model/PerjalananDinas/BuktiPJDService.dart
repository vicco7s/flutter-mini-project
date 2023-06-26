class BuktiKegiatan {
  final String uid;
  final String dasar;
  final String nama;
  final String nip;
  final String jabatan;
  final String keperluan;
  final String tempat;
  final DateTime firstDate;
  final DateTime endDate;
  final String hasil;
  late List<String> imageUrl;

  BuktiKegiatan({
    required this.uid,
    required this.dasar,
    required this.nama,
    required this.nip,
    required this.jabatan,
    required this.keperluan,
    required this.tempat,
    required this.firstDate,
    required this.endDate,
    required this.hasil,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
      'uid': uid,
      'dasar': dasar,
      'nama': nama,
      'nip': nip,
      'jabatan': jabatan,
      'keperluan': keperluan,
      'tempat': tempat,
      'tgl_awal': firstDate,
      'tgl_akhir': endDate,
      'hasil': hasil,
      'imageUrl': imageUrl,
    };
}

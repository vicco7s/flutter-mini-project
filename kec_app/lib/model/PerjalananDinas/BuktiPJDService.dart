class BuktiKegiatan {
  final String uid;
  final String no_berkas;
  final String alamat_pengirim;
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
    required this.no_berkas,
    required this.alamat_pengirim,
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
        'no_berkas':no_berkas,
        'alamat_pengirim': alamat_pengirim,
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

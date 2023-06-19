class BuktiKegiatan {
  final String dasar;
  final String nama;
  final String nip;
  final String jabatan;
  final String keperluan;
  final String tempat;
  final DateTime firstDate;
  final DateTime endDate;
  final String hasil;

  BuktiKegiatan({
    required this.dasar,
    required this.nama,
    required this.nip,
    required this.jabatan,
    required this.keperluan,
    required this.tempat,
    required this.firstDate,
    required this.endDate,
    required this.hasil,
  });

  Map<String, dynamic> toJson() => {
    'dasar': dasar,
    'nama': nama,
    'nip': nip,
    'jabatan':jabatan,
    'keperluan': keperluan,
    'tempat': tempat,
    'tgl_awal': firstDate,
    'tgl_akhir': endDate,
    'hasil': hasil,
  };

}

class GajiHonor {
  final String nama;
  final String jabatan;
  final DateTime tanggal;
  final int gaji_honor;
  final int bonus;
  final int total;
  final String keterangan;

  GajiHonor({
    required this.nama,
    required this.jabatan,
    required this.tanggal,
    required this.gaji_honor,
    required this.bonus,
    required this.total,
    required this.keterangan,
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'jabatan': jabatan,
        'tanggal': tanggal,
        'gaji_honor': gaji_honor,
        'bonus': bonus,
        'total': total,
        'keterangan': keterangan,
      };
}

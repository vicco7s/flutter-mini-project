class InputSurel {
  final String noBerkas;
  final String alamat;
  final DateTime tanggal;
  final String perihal;
  final DateTime tanggal_terima;
  final String keterangan;

  InputSurel({
    required this.noBerkas,
    required this.alamat,
    required this.tanggal,
    required this.perihal,
    required this.tanggal_terima, required this.keterangan,
  });

  Map<String, dynamic> toJson() => {
        'no_berkas': noBerkas,
        'alamat_pengirim': alamat,
        'tanggal': tanggal,
        'perihal': perihal,
        'tanggal_terima' : tanggal_terima,
        'keterangan' : keterangan,
      };
}

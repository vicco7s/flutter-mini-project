class OutputSurel {
  final String noBerkas;
  final String alamat;
  final DateTime tanggal;
  final String perihal;
  final String keterangan;

  OutputSurel( {
    required this.noBerkas,
    required this.alamat,
    required this.tanggal,
    required this.perihal,
    required this.keterangan,
  });

  Map<String, dynamic> toJson() => {
        'no_berkas': noBerkas,
        'alamat_penerima': alamat,
        'tanggal': tanggal,
        'perihal': perihal,
        'keterangan': keterangan,
      };
}

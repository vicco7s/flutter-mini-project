class SuratBatal {
  final String nama;
  final DateTime tanggal_surat;
  final DateTime  tanggal_perjalanan;
  final String alasan;
  final String status;
  final String keterangan;

  SuratBatal({
    required this.nama,
    required this.tanggal_surat,
    required this.tanggal_perjalanan,
    required this.alasan,
    required this.status,
    required this.keterangan,
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'tanggal_surat': tanggal_surat,
        'tanggal_perjalanan': tanggal_perjalanan,
        'alasan': alasan,
        'status': status,
        'keterangan': keterangan,
      };
}

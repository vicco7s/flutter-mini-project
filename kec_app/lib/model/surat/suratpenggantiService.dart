class SuratPenggantiService {
  final String nama;
  final String nama_pengganti;
  final String jabatan;
  final DateTime tanggal_surat;
  final DateTime tanggal_perjalanan;
  final String alasan;

  SuratPenggantiService({
    required this.nama,
    required this.nama_pengganti,
    required this.jabatan,
    required this.tanggal_surat,
    required this.tanggal_perjalanan,
    required this.alasan,
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nama_pengganti': nama_pengganti,
        'jabatan': jabatan,
        'tanggal_surat': tanggal_surat,
        'tanggal_perjalanan': tanggal_perjalanan,
        'alasan': alasan,
      };
}

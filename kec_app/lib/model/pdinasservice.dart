class InputDinas {
  final String nama;
  final String nip;
  final String jabatan;
  final String tujuan;
  final String keperluan;
  final DateTime tanggal_berangkat;
  final DateTime tanggal_berakhir;
  final int uangharian;
  final int hari;
  final int transport;
  final int pulang_pergi;
  final int penginapan;
  final int lama_menginap;
  final int jumlah_total;
  final String status;
  final String konfirmasi_kirim;

  InputDinas({
    required this.nama,
    required this.nip,
    required this.jabatan,
    required this.tujuan,
    required this.keperluan,
    required this.tanggal_berangkat,
    required this.tanggal_berakhir,
    required this.uangharian,
    required this.hari,
    required this.transport,
    required this.pulang_pergi,
    required this.penginapan,
    required this.lama_menginap,
    required this.jumlah_total,
    required this.status,
    required this.konfirmasi_kirim,
  });
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nip' : nip,
        'jabatan': jabatan,
        'tujuan': tujuan,
        'keperluan': keperluan,
        'tanggal_mulai': tanggal_berangkat,
        'tanggal_berakhir': tanggal_berakhir,
        'uangharian': uangharian,
        'hari': hari,
        'transport': transport,
        'pulang_pergi': pulang_pergi,
        'penginapan': penginapan,
        'lama_menginap': lama_menginap,
        'total': jumlah_total,
        'status': status,
        'konfirmasi_kirim': konfirmasi_kirim,
      };
}

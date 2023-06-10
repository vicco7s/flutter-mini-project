class InputAsn {
  final String nama;
  final String nip;
  final String jenis_kelamin;
  final DateTime tgl_lahir;
  final String tempat_lahir;
  final DateTime tanggal_mulai_tugas;
  final String alamat;
  final String pendidikan_terakhir;
  final String pangkat;
  final String golongan;
  final String jabatan;
  final String status;
  final String status_perkawinan;
  final int jumlah_anak;
  final String telp;
  String? imageUrl;

  InputAsn({
    required this.nama,
    required this.nip,
    required this.jenis_kelamin,
    required this.tgl_lahir,
    required this.tempat_lahir,
    required this.tanggal_mulai_tugas,
    required this.alamat,
    required this.pendidikan_terakhir,
    required this.pangkat,
    required this.golongan,
    required this.jabatan,
    required this.status,
    required this.status_perkawinan,
    required this.jumlah_anak,
    required this.telp,
    required this.imageUrl
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nip': nip,
        'jenis_kelamin': jenis_kelamin,
        'tgl_lahir': tgl_lahir,
        'tempat_lahir': tempat_lahir,
        'tgl_mulaitugas': tanggal_mulai_tugas,
        'alamat': alamat,
        'pendidikan_terakhir': pendidikan_terakhir,
        'pangkat': pangkat,
        'golongan': golongan,
        'jabatan': jabatan,
        'status': status,
        'status_pernikahan': status_perkawinan,
        'jumlah_anak': jumlah_anak,
        'telpon': telp,
        'imageUrl': imageUrl
      };
}

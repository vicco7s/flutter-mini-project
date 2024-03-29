class InputAsn {
  final String uid;
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
  final String agama;
  final int jumlah_anak;
  final String telp;
  String? imageUrl;
  String? imageKtp;
  late List<String> riwayatPendidikan;
  late List<String> riwayatKerja;

  InputAsn(
      {required this.uid,
      required this.nama,
      required this.agama,
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
      required this.imageUrl,
      required this.imageKtp,
      required this.riwayatKerja,
      required this.riwayatPendidikan});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'nama': nama,
        'nip': nip,
        'agama': agama,
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
        'imageUrl': imageUrl,
        'imageKtp': imageKtp,
        'riwayat_kerja': riwayatKerja,
        'riwayat_pendidikan': riwayatPendidikan,
      };
}

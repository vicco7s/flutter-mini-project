class InputDinas {
  final String nama;
  final String tujuan;
  final String keperluan;
  final DateTime tanggal_berangkat;
  final DateTime tanggal_berakhir;
  final String status;

  InputDinas({
      required this.nama, 
      required this.tujuan, 
      required this.keperluan, 
      required this.tanggal_berangkat, 
      required this.tanggal_berakhir, 
      required this.status
    });
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'tujuan': tujuan,
        'keperluan': keperluan,
        'tanggal_mulai': tanggal_berangkat,
        'tanggal_berakhir' : tanggal_berakhir,
        'status' : status,
    };
}

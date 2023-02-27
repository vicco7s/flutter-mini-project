

class InputAsn {
  final String nama;
  final int nip;
  final String pangkat;
  final String golongan;
  final String jabatan;
  final String status;

  InputAsn({
    required this.nama, 
    required this.nip, 
    required this.pangkat, 
    required this.golongan, 
    required this.jabatan, 
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nip': nip,
        'pangkat': pangkat,
        'golongan': golongan,
        'jabatan' : jabatan,
        'status' : status,
      };
}

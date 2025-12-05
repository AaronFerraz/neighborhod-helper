class MockAuth {
  // Initial mock users (email/CPF as identifier)
  static final List<Map<String, String>> _users = [
    {
      'email': 'admin@vizinhanca.com',
      'password': 'admin123',
      'name': 'Administrador'
    },
    {
      'email': 'morador@email.com',
      'password': 'morador123',
      'name': 'Morador Exemplo'
    },
    {'email': '12345678901', 'password': 'cpf123', 'name': 'Usuário CPF'},
    {
      'email': 'sindico@condominio.com',
      'password': 'sindico123',
      'name': 'Síndico'
    },
  ];

  static bool authenticateUser(String emailOrCpf, String password) {
    return _users
        .any((u) => u['email'] == emailOrCpf && u['password'] == password);
  }

  static bool isEmailOrCpfRegistered(String emailOrCpf) {
    return _users.any((u) => u['email'] == emailOrCpf);
  }

  static void registerUser({
    required String name,
    required String emailOrCpf,
    required String password,
    required String phone,
    required String condominium,
    required String unitType,
    required String unitId,
  }) {
    // For mock purposes, do a simple check and then add the record.
    if (isEmailOrCpfRegistered(emailOrCpf)) {
      throw Exception('Usuário já cadastrado');
    }

    _users.add({
      'name': name,
      'email': emailOrCpf,
      'password': password,
      'phone': phone,
      'condominium': condominium,
      'unitType': unitType,
      'unitId': unitId,
    });
  }

  // Expose users for debugging (mock only)
  static List<Map<String, String>> get users => List.unmodifiable(_users);
}

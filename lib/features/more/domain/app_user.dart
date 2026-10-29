/// A Caspian account as the admin sees it (read-only in this app; managed
/// in the server's admin panel).
enum UserRole { owner, warehouse, admin, unassigned }

/// Approval of an account registered by SMS code.
enum UserApproval { approved, pending, rejected }

class AppUser {
  const new({
    required this.id,
    required this.nameFa,
    required this.role,
    required this.active,
    required this.approval,
  });

  final String id;
  final String nameFa;
  final UserRole role;
  final bool active;
  final UserApproval approval;
}

/// «کاربران و دسترسی‌ها» (admins only).
abstract interface class UsersRepository {
  Future<List<AppUser>> list();
}

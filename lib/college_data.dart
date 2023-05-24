enum ConditionsList {
  hypertension,
  tubercolosis,
  diabetes,
  cancer,
  kidney_disease,
  cardiac_disease,
  autoimmune_disease,
  asthma
}

class CollegeData {
  static List<String> get colleges => _colleges;

  static final List<String> _colleges = [
    "College of Agriculture and Food Science",
    "College of Arts and Sciences",
    "College of Development Communication",
    "College of Economics and Management",
    "College of Engineering and Agro-Industrial Technology",
    "School of Environmental Science and Management",
    "College of Forestry and Natural Resources",
    "Graduate School",
    "College of Human Ecology",
    "College of Public Affairs and Development",
    "College of Veterinary Medicine"
  ];

  static final List<String> _allowedEmailDomains = [
    "up.edu.ph",
    "uplb.edu.ph",
    "outlook.up.edu.ph"
  ];

  static bool isValidEmail(String email) {
    for (String domain in _allowedEmailDomains) {
      if (email.endsWith(domain)) return true;
    }

    return false;
  }
}

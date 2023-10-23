class Note {
  // Utilisation de variables non privées pour rendre les membres accessibles directement
  int id = 0;
  String title;
  String description;
  String date;
  int priority;

  // Constructeur par défaut avec des valeurs par défaut pour la description
  Note(this.title, this.date, this.priority, [this.description = ""]);

  // Constructeur avec ID
  Note.withId(this.id, this.title, this.date, this.priority,
      [this.description = ""]);

  // Méthode pour créer un objet Map à partir d'une instance de Note
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'priority': priority,
      'date': date,
    };
    return map;
  }

  // Constructeur nommé pour créer une instance de Note à partir d'un objet Map
  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    priority = map['priority'];
    date = map['date'];
  }

  // Méthode pour définir la priorité avec une vérification de la plage valide
  void setPriority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      priority = newPriority;
    }
  }

  // Méthode pour définir la date
  void setDate(String newDate) {
    date = newDate;
  }

  // Méthode pour définir la description avec une vérification de la longueur
  void setDescription(String newDescription) {
    if (newDescription.length <= 255) {
      description = newDescription;
    }
  }

  // Méthode pour définir le titre avec une vérification de la longueur
  void setTitle(String newTitle) {
    if (newTitle.length <= 255) {
      title = newTitle;
    }
  }
}

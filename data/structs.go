package data

type BookData struct {
  ID            string
  Title         string
  Authors       []string
  Publisher     string
  PublishDate   string
  ISBN10        string
  ISBN13        string
  Cover         string
  Category      []string
  Language      string
  Format        string
  Owner         string
  Location      string
  Status        int
  Condition     int
  Privacy       int
}

type UserData struck {
  ID            string
  FirstName     string
  LastName      string
  UserName      string
  Role          int
}

type PageData struct {
  User          UserData
  Books         []BookData
}
